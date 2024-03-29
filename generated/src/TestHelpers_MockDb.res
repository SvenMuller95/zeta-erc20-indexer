/***** TAKE NOTE ******
This file module is a hack to get genType to work!

In order for genType to produce recursive types, it needs to be at the 
root module of a file. If it's defined in a nested module it does not 
work. So all the MockDb types and internal functions are defined here in TestHelpers_MockDb
and only public functions are recreated and exported from TestHelpers.MockDb module.

the following module:
```rescript
module MyModule = {
  @genType
  type rec a = {fieldB: b}
  @genType and b = {fieldA: a}
}
```

produces the following in ts:
```ts
// tslint:disable-next-line:interface-over-type-literal
export type MyModule_a = { readonly fieldB: b };

// tslint:disable-next-line:interface-over-type-literal
export type MyModule_b = { readonly fieldA: MyModule_a };
```

fieldB references type b which doesn't exist because it's defined
as MyModule_b
*/

open Belt

/**
A raw js binding to allow deleting from a dict. Used in store delete operation
*/
let deleteDictKey: (Js.Dict.t<'a>, string) => unit = %raw(`
    function(dict, key) {
      delete dict[key]
    }
  `)

/**
The mockDb type is simply an InMemoryStore internally. __dbInternal__ holds a reference
to an inMemoryStore and all the the accessor methods point to the reference of that inMemory
store
*/
@genType
type rec t = {
  __dbInternal__: IO.InMemoryStore.t,
  entities: entities,
  rawEvents: storeOperations<IO.InMemoryStore.rawEventsKey, Types.rawEventsEntity>,
  eventSyncState: storeOperations<Types.chainId, DbFunctions.EventSyncState.eventSyncState>,
  dynamicContractRegistry: storeOperations<
    IO.InMemoryStore.dynamicContractRegistryKey,
    Types.dynamicContractRegistryEntity,
  >,
}

// Each user defined entity will be in this record with all the store or "mockdb" operators
@genType
and entities = {
  @as("EventsSummary") eventsSummary: entityStoreOperations<Types.eventsSummaryEntity>,
  @as("ZETA_Approval") zETA_Approval: entityStoreOperations<Types.zETA_ApprovalEntity>,
  @as("ZETA_ClaimReward") zETA_ClaimReward: entityStoreOperations<Types.zETA_ClaimRewardEntity>,
  @as("ZETA_Deposit") zETA_Deposit: entityStoreOperations<Types.zETA_DepositEntity>,
  @as("ZETA_NewRewardPool")
  zETA_NewRewardPool: entityStoreOperations<Types.zETA_NewRewardPoolEntity>,
  @as("ZETA_Transfer") zETA_Transfer: entityStoreOperations<Types.zETA_TransferEntity>,
  @as("ZETA_Withdrawal") zETA_Withdrawal: entityStoreOperations<Types.zETA_WithdrawalEntity>,
}
// User defined entities always have a string for an id which is used as the
// key for entity stores
@genType and entityStoreOperations<'entity> = storeOperations<string, 'entity>
// all the operator functions a user can access on an entity in the mock db
// stores refer to the the module that MakeStore functor outputs in IO.res
@genType
and storeOperations<'entityKey, 'entity> = {
  getAll: unit => array<'entity>,
  get: 'entityKey => option<'entity>,
  set: 'entity => t,
  delete: 'entityKey => t,
}

module type StoreState = {
  type value
  type key
  let get: (IO.InMemoryStore.storeState<value, key>, key) => option<value>
  let values: IO.InMemoryStore.storeState<value, key> => array<Types.inMemoryStoreRow<value>>
  let set: (
    IO.InMemoryStore.storeState<value, key>,
    ~key: key,
    ~dbOp: Types.dbOp,
    ~entity: value,
  ) => unit
}

// /**
// a composable function to make the "storeOperations" record to represent all the mock
// db operations for each entity.
// */
let makeStoreOperator = (
  type entity key,
  storeStateMod: module(StoreState with type value = entity and type key = key),
  ~inMemoryStore: IO.InMemoryStore.t,
  ~makeMockDb,
  ~getStore: IO.InMemoryStore.t => IO.InMemoryStore.storeState<entity, key>,
  ~getKey: entity => key,
): storeOperations<key, entity> => {
  let module(StoreState) = storeStateMod
  let {get, values, set} = module(StoreState)

  let get = inMemoryStore->getStore->get
  let getAll = () => inMemoryStore->getStore->values->Array.map(row => row.entity)

  let set = entity => {
    let cloned = inMemoryStore->IO.InMemoryStore.clone
    cloned->getStore->set(~key=entity->getKey, ~entity, ~dbOp=Set)
    cloned->makeMockDb
  }

  let delete = key => {
    let cloned = inMemoryStore->IO.InMemoryStore.clone
    let store = cloned->getStore
    store.dict->deleteDictKey(key->store.hasher)
    cloned->makeMockDb
  }

  {
    getAll,
    get,
    set,
    delete,
  }
}

/**
The internal make function which can be passed an in memory store and
instantiate a "MockDb". This is useful for cloning or making a MockDb
out of an existing inMemoryStore
*/
let rec makeWithInMemoryStore = (inMemoryStore: IO.InMemoryStore.t) => {
  let rawEvents = module(IO.InMemoryStore.RawEvents)->makeStoreOperator(
    ~inMemoryStore,
    ~makeMockDb=makeWithInMemoryStore,
    ~getStore=db => db.rawEvents,
    ~getKey=({chainId, eventId}) => {
      chainId,
      eventId,
    },
  )

  let eventSyncState =
    module(IO.InMemoryStore.EventSyncState)->makeStoreOperator(
      ~inMemoryStore,
      ~makeMockDb=makeWithInMemoryStore,
      ~getStore=db => db.eventSyncState,
      ~getKey=({chainId}) => chainId,
    )

  let dynamicContractRegistry =
    module(IO.InMemoryStore.DynamicContractRegistry)->makeStoreOperator(
      ~inMemoryStore,
      ~getStore=db => db.dynamicContractRegistry,
      ~makeMockDb=makeWithInMemoryStore,
      ~getKey=({chainId, contractAddress}) => {chainId, contractAddress},
    )

  let entities = {
    eventsSummary: {
      module(IO.InMemoryStore.EventsSummary)->makeStoreOperator(
        ~inMemoryStore,
        ~makeMockDb=makeWithInMemoryStore,
        ~getStore=db => db.eventsSummary,
        ~getKey=({id}) => id,
      )
    },
    zETA_Approval: {
      module(IO.InMemoryStore.ZETA_Approval)->makeStoreOperator(
        ~inMemoryStore,
        ~makeMockDb=makeWithInMemoryStore,
        ~getStore=db => db.zETA_Approval,
        ~getKey=({id}) => id,
      )
    },
    zETA_ClaimReward: {
      module(IO.InMemoryStore.ZETA_ClaimReward)->makeStoreOperator(
        ~inMemoryStore,
        ~makeMockDb=makeWithInMemoryStore,
        ~getStore=db => db.zETA_ClaimReward,
        ~getKey=({id}) => id,
      )
    },
    zETA_Deposit: {
      module(IO.InMemoryStore.ZETA_Deposit)->makeStoreOperator(
        ~inMemoryStore,
        ~makeMockDb=makeWithInMemoryStore,
        ~getStore=db => db.zETA_Deposit,
        ~getKey=({id}) => id,
      )
    },
    zETA_NewRewardPool: {
      module(IO.InMemoryStore.ZETA_NewRewardPool)->makeStoreOperator(
        ~inMemoryStore,
        ~makeMockDb=makeWithInMemoryStore,
        ~getStore=db => db.zETA_NewRewardPool,
        ~getKey=({id}) => id,
      )
    },
    zETA_Transfer: {
      module(IO.InMemoryStore.ZETA_Transfer)->makeStoreOperator(
        ~inMemoryStore,
        ~makeMockDb=makeWithInMemoryStore,
        ~getStore=db => db.zETA_Transfer,
        ~getKey=({id}) => id,
      )
    },
    zETA_Withdrawal: {
      module(IO.InMemoryStore.ZETA_Withdrawal)->makeStoreOperator(
        ~inMemoryStore,
        ~makeMockDb=makeWithInMemoryStore,
        ~getStore=db => db.zETA_Withdrawal,
        ~getKey=({id}) => id,
      )
    },
  }

  {__dbInternal__: inMemoryStore, entities, rawEvents, eventSyncState, dynamicContractRegistry}
}

//Note: It's called createMockDb over "make" to make it more intuitive in JS and TS

/**
The constructor function for a mockDb. Call it and then set up the inital state by calling
any of the set functions it provides access to. A mockDb will be passed into a processEvent 
helper. Note, process event helpers will not mutate the mockDb but return a new mockDb with
new state so you can compare states before and after.
*/
@genType
let createMockDb = () => makeWithInMemoryStore(IO.InMemoryStore.make())

/**
Accessor function for getting the internal inMemoryStore in the mockDb
*/
let getInternalDb = (self: t) => self.__dbInternal__

/**
Deep copies the in memory store data and returns a new mockDb with the same
state and no references to data from the passed in mockDb
*/
let cloneMockDb = (self: t) => {
  let clonedInternalDb = self->getInternalDb->IO.InMemoryStore.clone
  clonedInternalDb->makeWithInMemoryStore
}

/**
Specifically create an executor for the mockDb
*/
let makeMockDbEntityExecuter = (~idsToLoad, ~dbReadFn, ~inMemStoreSetFn, ~store, ~getEntiyId) => {
  let dbReadFn = idsArr => idsArr->Belt.Array.keepMap(id => id->dbReadFn)
  IO.makeEntityExecuterComposer(
    ~idsToLoad,
    ~dbReadFn,
    ~inMemStoreSetFn,
    ~store,
    ~getEntiyId,
    ~unit=(),
    ~then=(res, fn) => res->fn,
  )
}

/**
Executes a single load layer using the mockDb functions
*/
let executeMockDbLoadLayer = (
  mockDb: t,
  ~loadLayer: IO.LoadLayer.t,
  ~inMemoryStore: IO.InMemoryStore.t,
) => {
  let entityExecutors = [
    makeMockDbEntityExecuter(
      ~idsToLoad=loadLayer.eventsSummaryIdsToLoad,
      ~dbReadFn=mockDb.entities.eventsSummary.get,
      ~inMemStoreSetFn=IO.InMemoryStore.EventsSummary.set,
      ~store=inMemoryStore.eventsSummary,
      ~getEntiyId=entity => entity.id,
    ),
    makeMockDbEntityExecuter(
      ~idsToLoad=loadLayer.zETA_ApprovalIdsToLoad,
      ~dbReadFn=mockDb.entities.zETA_Approval.get,
      ~inMemStoreSetFn=IO.InMemoryStore.ZETA_Approval.set,
      ~store=inMemoryStore.zETA_Approval,
      ~getEntiyId=entity => entity.id,
    ),
    makeMockDbEntityExecuter(
      ~idsToLoad=loadLayer.zETA_ClaimRewardIdsToLoad,
      ~dbReadFn=mockDb.entities.zETA_ClaimReward.get,
      ~inMemStoreSetFn=IO.InMemoryStore.ZETA_ClaimReward.set,
      ~store=inMemoryStore.zETA_ClaimReward,
      ~getEntiyId=entity => entity.id,
    ),
    makeMockDbEntityExecuter(
      ~idsToLoad=loadLayer.zETA_DepositIdsToLoad,
      ~dbReadFn=mockDb.entities.zETA_Deposit.get,
      ~inMemStoreSetFn=IO.InMemoryStore.ZETA_Deposit.set,
      ~store=inMemoryStore.zETA_Deposit,
      ~getEntiyId=entity => entity.id,
    ),
    makeMockDbEntityExecuter(
      ~idsToLoad=loadLayer.zETA_NewRewardPoolIdsToLoad,
      ~dbReadFn=mockDb.entities.zETA_NewRewardPool.get,
      ~inMemStoreSetFn=IO.InMemoryStore.ZETA_NewRewardPool.set,
      ~store=inMemoryStore.zETA_NewRewardPool,
      ~getEntiyId=entity => entity.id,
    ),
    makeMockDbEntityExecuter(
      ~idsToLoad=loadLayer.zETA_TransferIdsToLoad,
      ~dbReadFn=mockDb.entities.zETA_Transfer.get,
      ~inMemStoreSetFn=IO.InMemoryStore.ZETA_Transfer.set,
      ~store=inMemoryStore.zETA_Transfer,
      ~getEntiyId=entity => entity.id,
    ),
    makeMockDbEntityExecuter(
      ~idsToLoad=loadLayer.zETA_WithdrawalIdsToLoad,
      ~dbReadFn=mockDb.entities.zETA_Withdrawal.get,
      ~inMemStoreSetFn=IO.InMemoryStore.ZETA_Withdrawal.set,
      ~store=inMemoryStore.zETA_Withdrawal,
      ~getEntiyId=entity => entity.id,
    ),
  ]
  let handleResponses = _ => {
    IO.getNextLayer(~loadLayer)
  }

  IO.executeLoadLayerComposer(~entityExecutors, ~handleResponses)
}

/**
Given an isolated inMemoryStore and an array of read entities. This function loads the 
requested data from the mockDb into the inMemory store. Simulating how loading happens
from and external db into the inMemoryStore for a batch during event processing
*/
let loadEntitiesToInMemStore = (mockDb, ~entityBatch, ~inMemoryStore) => {
  let executeLoadLayerFn = mockDb->executeMockDbLoadLayer
  //In an async handler this would be a Promise.then... in this case
  //just need to return the value and pass it into the callback
  let then = (res, fn) => res->fn
  IO.loadEntitiesToInMemStoreComposer(
    ~inMemoryStore,
    ~entityBatch,
    ~executeLoadLayerFn,
    ~then,
    ~unit=(),
  )
}

/**
A function composer for simulating the writing of an inMemoryStore to the external db with a mockDb.
Runs all set and delete operations currently cached in an inMemory store against the mockDb
*/
let executeRows = (
  mockDb: t,
  ~inMemoryStore: IO.InMemoryStore.t,
  ~getStore: IO.InMemoryStore.t => IO.InMemoryStore.storeState<'entity, 'key>,
  ~getRows: IO.InMemoryStore.storeState<'entity, 'key> => array<Types.inMemoryStoreRow<'entity>>,
  ~getKey: 'entity => 'key,
  ~setFunction: (
    IO.InMemoryStore.storeState<'entity, 'key>,
    ~key: 'key,
    ~dbOp: Types.dbOp,
    ~entity: 'entity,
  ) => unit,
) => {
  inMemoryStore
  ->getStore
  ->getRows
  ->Array.forEach(row => {
    let store = mockDb->getInternalDb->getStore
    switch row.dbOp {
    | Set => store->setFunction(~dbOp=Read, ~key=getKey(row.entity), ~entity=row.entity)
    | Delete => store.dict->deleteDictKey(row.entity->getKey->store.hasher)
    | Read => ()
    }
  })
}

/**
Simulates the writing of processed data in the inMemoryStore to a mockDb. This function
executes all the rows on each "store" (or pg table) in the inMemoryStore
*/
let writeFromMemoryStore = (mockDb: t, ~inMemoryStore: IO.InMemoryStore.t) => {
  open IO
  //INTERNAL STORES/TABLES EXECUTION
  mockDb->executeRows(
    ~inMemoryStore,
    ~getRows=InMemoryStore.RawEvents.values,
    ~getStore=inMemStore => {inMemStore.rawEvents},
    ~setFunction=InMemoryStore.RawEvents.set,
    ~getKey=(entity): IO.InMemoryStore.rawEventsKey => {
      chainId: entity.chainId,
      eventId: entity.eventId,
    },
  )

  mockDb->executeRows(
    ~inMemoryStore,
    ~getStore=inMemStore => {inMemStore.eventSyncState},
    ~getRows=InMemoryStore.EventSyncState.values,
    ~setFunction=InMemoryStore.EventSyncState.set,
    ~getKey=entity => entity.chainId,
  )

  mockDb->executeRows(
    ~inMemoryStore,
    ~getRows=InMemoryStore.DynamicContractRegistry.values,
    ~getStore=inMemStore => {inMemStore.dynamicContractRegistry},
    ~setFunction=InMemoryStore.DynamicContractRegistry.set,
    ~getKey=(entity): IO.InMemoryStore.dynamicContractRegistryKey => {
      chainId: entity.chainId,
      contractAddress: entity.contractAddress,
    },
  )

  //ENTITY EXECUTION
  mockDb->executeRows(
    ~inMemoryStore,
    ~getStore=self => {self.eventsSummary},
    ~getRows=IO.InMemoryStore.EventsSummary.values,
    ~setFunction=IO.InMemoryStore.EventsSummary.set,
    ~getKey=entity => entity.id,
  )
  mockDb->executeRows(
    ~inMemoryStore,
    ~getStore=self => {self.zETA_Approval},
    ~getRows=IO.InMemoryStore.ZETA_Approval.values,
    ~setFunction=IO.InMemoryStore.ZETA_Approval.set,
    ~getKey=entity => entity.id,
  )
  mockDb->executeRows(
    ~inMemoryStore,
    ~getStore=self => {self.zETA_ClaimReward},
    ~getRows=IO.InMemoryStore.ZETA_ClaimReward.values,
    ~setFunction=IO.InMemoryStore.ZETA_ClaimReward.set,
    ~getKey=entity => entity.id,
  )
  mockDb->executeRows(
    ~inMemoryStore,
    ~getStore=self => {self.zETA_Deposit},
    ~getRows=IO.InMemoryStore.ZETA_Deposit.values,
    ~setFunction=IO.InMemoryStore.ZETA_Deposit.set,
    ~getKey=entity => entity.id,
  )
  mockDb->executeRows(
    ~inMemoryStore,
    ~getStore=self => {self.zETA_NewRewardPool},
    ~getRows=IO.InMemoryStore.ZETA_NewRewardPool.values,
    ~setFunction=IO.InMemoryStore.ZETA_NewRewardPool.set,
    ~getKey=entity => entity.id,
  )
  mockDb->executeRows(
    ~inMemoryStore,
    ~getStore=self => {self.zETA_Transfer},
    ~getRows=IO.InMemoryStore.ZETA_Transfer.values,
    ~setFunction=IO.InMemoryStore.ZETA_Transfer.set,
    ~getKey=entity => entity.id,
  )
  mockDb->executeRows(
    ~inMemoryStore,
    ~getStore=self => {self.zETA_Withdrawal},
    ~getRows=IO.InMemoryStore.ZETA_Withdrawal.values,
    ~setFunction=IO.InMemoryStore.ZETA_Withdrawal.set,
    ~getKey=entity => entity.id,
  )
}
