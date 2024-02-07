module InMemoryStore = {
  let entityCurrentCrud = (currentCrud: option<Types.dbOp>, nextCrud: Types.dbOp): Types.dbOp => {
    switch (currentCrud, nextCrud) {
    | (Some(Set), Read)
    | (_, Set) =>
      Set
    | (Some(Read), Read) => Read
    | (Some(Delete), Read)
    | (_, Delete) =>
      Delete
    | (None, _) => nextCrud
    }
  }

  type stringHasher<'val> = 'val => string
  type storeState<'entity, 'entityKey> = {
    dict: Js.Dict.t<Types.inMemoryStoreRow<'entity>>,
    hasher: stringHasher<'entityKey>,
  }

  module type StoreItem = {
    type t
    type key
    let hasher: stringHasher<key>
  }

  //Binding used for deep cloning stores in tests
  @val external structuredClone: 'a => 'a = "structuredClone"

  module MakeStore = (StoreItem: StoreItem) => {
    type value = StoreItem.t
    type key = StoreItem.key
    type t = storeState<value, key>

    let make = (): t => {dict: Js.Dict.empty(), hasher: StoreItem.hasher}

    let set = (self: t, ~key: StoreItem.key, ~dbOp, ~entity: StoreItem.t) =>
      self.dict->Js.Dict.set(key->self.hasher, {entity, dbOp})

    let get = (self: t, key: StoreItem.key) =>
      self.dict->Js.Dict.get(key->self.hasher)->Belt.Option.map(row => row.entity)

    let values = (self: t) => self.dict->Js.Dict.values

    let clone = (self: t) => {
      ...self,
      dict: self.dict->structuredClone,
    }
  }

  module EventSyncState = MakeStore({
    type t = DbFunctions.EventSyncState.eventSyncState
    type key = int
    let hasher = Belt.Int.toString
  })

  @genType
  type rawEventsKey = {
    chainId: int,
    eventId: string,
  }

  module RawEvents = MakeStore({
    type t = Types.rawEventsEntity
    type key = rawEventsKey
    let hasher = (key: key) =>
      EventUtils.getEventIdKeyString(~chainId=key.chainId, ~eventId=key.eventId)
  })

  @genType
  type dynamicContractRegistryKey = {
    chainId: int,
    contractAddress: Ethers.ethAddress,
  }

  module DynamicContractRegistry = MakeStore({
    type t = Types.dynamicContractRegistryEntity
    type key = dynamicContractRegistryKey
    let hasher = ({chainId, contractAddress}) =>
      EventUtils.getContractAddressKeyString(~chainId, ~contractAddress)
  })

  module EventsSummary = MakeStore({
    type t = Types.eventsSummaryEntity
    type key = string
    let hasher = Obj.magic
  })

  module ZETA_Approval = MakeStore({
    type t = Types.zETA_ApprovalEntity
    type key = string
    let hasher = Obj.magic
  })

  module ZETA_ClaimReward = MakeStore({
    type t = Types.zETA_ClaimRewardEntity
    type key = string
    let hasher = Obj.magic
  })

  module ZETA_Deposit = MakeStore({
    type t = Types.zETA_DepositEntity
    type key = string
    let hasher = Obj.magic
  })

  module ZETA_NewRewardPool = MakeStore({
    type t = Types.zETA_NewRewardPoolEntity
    type key = string
    let hasher = Obj.magic
  })

  module ZETA_Transfer = MakeStore({
    type t = Types.zETA_TransferEntity
    type key = string
    let hasher = Obj.magic
  })

  module ZETA_Withdrawal = MakeStore({
    type t = Types.zETA_WithdrawalEntity
    type key = string
    let hasher = Obj.magic
  })

  @genType
  type t = {
    eventSyncState: EventSyncState.t,
    rawEvents: RawEvents.t,
    dynamicContractRegistry: DynamicContractRegistry.t,
    eventsSummary: EventsSummary.t,
    zETA_Approval: ZETA_Approval.t,
    zETA_ClaimReward: ZETA_ClaimReward.t,
    zETA_Deposit: ZETA_Deposit.t,
    zETA_NewRewardPool: ZETA_NewRewardPool.t,
    zETA_Transfer: ZETA_Transfer.t,
    zETA_Withdrawal: ZETA_Withdrawal.t,
  }

  let make = (): t => {
    eventSyncState: EventSyncState.make(),
    rawEvents: RawEvents.make(),
    dynamicContractRegistry: DynamicContractRegistry.make(),
    eventsSummary: EventsSummary.make(),
    zETA_Approval: ZETA_Approval.make(),
    zETA_ClaimReward: ZETA_ClaimReward.make(),
    zETA_Deposit: ZETA_Deposit.make(),
    zETA_NewRewardPool: ZETA_NewRewardPool.make(),
    zETA_Transfer: ZETA_Transfer.make(),
    zETA_Withdrawal: ZETA_Withdrawal.make(),
  }

  let clone = (self: t) => {
    eventSyncState: self.eventSyncState->EventSyncState.clone,
    rawEvents: self.rawEvents->RawEvents.clone,
    dynamicContractRegistry: self.dynamicContractRegistry->DynamicContractRegistry.clone,
    eventsSummary: self.eventsSummary->EventsSummary.clone,
    zETA_Approval: self.zETA_Approval->ZETA_Approval.clone,
    zETA_ClaimReward: self.zETA_ClaimReward->ZETA_ClaimReward.clone,
    zETA_Deposit: self.zETA_Deposit->ZETA_Deposit.clone,
    zETA_NewRewardPool: self.zETA_NewRewardPool->ZETA_NewRewardPool.clone,
    zETA_Transfer: self.zETA_Transfer->ZETA_Transfer.clone,
    zETA_Withdrawal: self.zETA_Withdrawal->ZETA_Withdrawal.clone,
  }
}

module LoadLayer = {
  /**The ids to load for a particular entity*/
  type idsToLoad = Belt.Set.String.t

  /**
  A round of entities to load from the DB. Depending on what entities come back
  and the dataLoaded "actions" that get run after the entities are loaded up. It
  could mean another load layer is created based of values that are returned
  */
  type rec t = {
    //A an array of getters to run after the entities with idsToLoad have been loaded
    dataLoadedActionsGetters: dataLoadedActionsGetters,
    //A unique list of ids that need to be loaded for entity eventsSummary
    eventsSummaryIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity zETA_Approval
    zETA_ApprovalIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity zETA_ClaimReward
    zETA_ClaimRewardIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity zETA_Deposit
    zETA_DepositIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity zETA_NewRewardPool
    zETA_NewRewardPoolIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity zETA_Transfer
    zETA_TransferIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity zETA_Withdrawal
    zETA_WithdrawalIdsToLoad: idsToLoad,
  }
  //An action that gets run after the data is loaded in from the db to the in memory store
  //the action will derive values from the loaded data and update the next load layer
  and dataLoadedAction = t => t
  //A getter function that returns an array of actions that need to be run
  //Actions will fetch values from the in memory store and update a load layer
  and dataLoadedActionsGetter = unit => array<dataLoadedAction>
  //An array of getter functions for dataLoadedActions
  and dataLoadedActionsGetters = array<dataLoadedActionsGetter>

  /**Instantiates a load layer*/
  let emptyLoadLayer = () => {
    eventsSummaryIdsToLoad: Belt.Set.String.empty,
    zETA_ApprovalIdsToLoad: Belt.Set.String.empty,
    zETA_ClaimRewardIdsToLoad: Belt.Set.String.empty,
    zETA_DepositIdsToLoad: Belt.Set.String.empty,
    zETA_NewRewardPoolIdsToLoad: Belt.Set.String.empty,
    zETA_TransferIdsToLoad: Belt.Set.String.empty,
    zETA_WithdrawalIdsToLoad: Belt.Set.String.empty,
    dataLoadedActionsGetters: [],
  }

  /* Helper to append an ID to load for a given entity to the loadLayer */
  let extendIdsToLoad = (idsToLoad: idsToLoad, entityId: Types.id): idsToLoad =>
    idsToLoad->Belt.Set.String.add(entityId)

  /* Helper to append a getter for DataLoadedActions to load for a given entity to the loadLayer */
  let extendDataLoadedActionsGetters = (
    dataLoadedActionsGetters: dataLoadedActionsGetters,
    newDataLoadedActionsGetters: dataLoadedActionsGetters,
  ): dataLoadedActionsGetters =>
    dataLoadedActionsGetters->Belt.Array.concat(newDataLoadedActionsGetters)
}

//remove warning 39 for unused "rec" flag in case of no other related loaders
/**
Loader functions for each entity. The loader function extends a load layer with the given id and config.
*/
@warning("-39")
let rec eventsSummaryLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~eventsSummaryLoaderConfig: Types.eventsSummaryLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "eventsSummaryLoaderConfig" type is a boolean.
  if !eventsSummaryLoaderConfig {
    //If eventsSummaryLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If eventsSummaryLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      eventsSummaryIdsToLoad: loadLayer.eventsSummaryIdsToLoad->LoadLayer.extendIdsToLoad(entityId),
    }
  }
}
@warning("-27")
and zETA_ApprovalLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~zETA_ApprovalLoaderConfig: Types.zETA_ApprovalLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "zETA_ApprovalLoaderConfig" type is a boolean.
  if !zETA_ApprovalLoaderConfig {
    //If zETA_ApprovalLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If zETA_ApprovalLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      zETA_ApprovalIdsToLoad: loadLayer.zETA_ApprovalIdsToLoad->LoadLayer.extendIdsToLoad(entityId),
    }
  }
}
@warning("-27")
and zETA_ClaimRewardLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~zETA_ClaimRewardLoaderConfig: Types.zETA_ClaimRewardLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "zETA_ClaimRewardLoaderConfig" type is a boolean.
  if !zETA_ClaimRewardLoaderConfig {
    //If zETA_ClaimRewardLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If zETA_ClaimRewardLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      zETA_ClaimRewardIdsToLoad: loadLayer.zETA_ClaimRewardIdsToLoad->LoadLayer.extendIdsToLoad(
        entityId,
      ),
    }
  }
}
@warning("-27")
and zETA_DepositLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~zETA_DepositLoaderConfig: Types.zETA_DepositLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "zETA_DepositLoaderConfig" type is a boolean.
  if !zETA_DepositLoaderConfig {
    //If zETA_DepositLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If zETA_DepositLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      zETA_DepositIdsToLoad: loadLayer.zETA_DepositIdsToLoad->LoadLayer.extendIdsToLoad(entityId),
    }
  }
}
@warning("-27")
and zETA_NewRewardPoolLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~zETA_NewRewardPoolLoaderConfig: Types.zETA_NewRewardPoolLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "zETA_NewRewardPoolLoaderConfig" type is a boolean.
  if !zETA_NewRewardPoolLoaderConfig {
    //If zETA_NewRewardPoolLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If zETA_NewRewardPoolLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      zETA_NewRewardPoolIdsToLoad: loadLayer.zETA_NewRewardPoolIdsToLoad->LoadLayer.extendIdsToLoad(
        entityId,
      ),
    }
  }
}
@warning("-27")
and zETA_TransferLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~zETA_TransferLoaderConfig: Types.zETA_TransferLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "zETA_TransferLoaderConfig" type is a boolean.
  if !zETA_TransferLoaderConfig {
    //If zETA_TransferLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If zETA_TransferLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      zETA_TransferIdsToLoad: loadLayer.zETA_TransferIdsToLoad->LoadLayer.extendIdsToLoad(entityId),
    }
  }
}
@warning("-27")
and zETA_WithdrawalLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~zETA_WithdrawalLoaderConfig: Types.zETA_WithdrawalLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "zETA_WithdrawalLoaderConfig" type is a boolean.
  if !zETA_WithdrawalLoaderConfig {
    //If zETA_WithdrawalLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If zETA_WithdrawalLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      zETA_WithdrawalIdsToLoad: loadLayer.zETA_WithdrawalIdsToLoad->LoadLayer.extendIdsToLoad(
        entityId,
      ),
    }
  }
}

/**
Creates and populates a load layer with the current in memory store and an array of entityRead variants
*/
let getLoadLayer = (~entityBatch: array<Types.entityRead>, ~inMemoryStore) => {
  entityBatch->Belt.Array.reduce(LoadLayer.emptyLoadLayer(), (loadLayer, readEntity) => {
    switch readEntity {
    | EventsSummaryRead(entityId) =>
      loadLayer->eventsSummaryLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~eventsSummaryLoaderConfig=true,
      )
    | ZETA_ApprovalRead(entityId) =>
      loadLayer->zETA_ApprovalLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~zETA_ApprovalLoaderConfig=true,
      )
    | ZETA_ClaimRewardRead(entityId) =>
      loadLayer->zETA_ClaimRewardLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~zETA_ClaimRewardLoaderConfig=true,
      )
    | ZETA_DepositRead(entityId) =>
      loadLayer->zETA_DepositLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~zETA_DepositLoaderConfig=true,
      )
    | ZETA_NewRewardPoolRead(entityId) =>
      loadLayer->zETA_NewRewardPoolLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~zETA_NewRewardPoolLoaderConfig=true,
      )
    | ZETA_TransferRead(entityId) =>
      loadLayer->zETA_TransferLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~zETA_TransferLoaderConfig=true,
      )
    | ZETA_WithdrawalRead(entityId) =>
      loadLayer->zETA_WithdrawalLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~zETA_WithdrawalLoaderConfig=true,
      )
    }
  })
}

/**
Represents whether a deeper layer needs to be executed or whether the last layer
has been executed
*/
type nextLayer = NextLayer(LoadLayer.t) | LastLayer

let getNextLayer = (~loadLayer: LoadLayer.t) =>
  switch loadLayer.dataLoadedActionsGetters {
  | [] => LastLayer
  | dataLoadedActionsGetters =>
    dataLoadedActionsGetters
    ->Belt.Array.reduce(LoadLayer.emptyLoadLayer(), (loadLayer, getLoadedActions) => {
      //call getLoadedActions returns array of of actions to run against the load layer
      getLoadedActions()->Belt.Array.reduce(loadLayer, (loadLayer, action) => {
        action(loadLayer)
      })
    })
    ->NextLayer
  }

/**
Used for composing a loadlayer executor
*/
type entityExecutor<'executorRes> = {
  idsToLoad: LoadLayer.idsToLoad,
  executor: LoadLayer.idsToLoad => 'executorRes,
}

/**
Compose an execute load layer function. Used to compose an executor
for a postgres db or a mock db in the testing framework.
*/
let executeLoadLayerComposer = (
  ~entityExecutors: array<entityExecutor<'exectuorRes>>,
  ~handleResponses: array<'exectuorRes> => 'nextLoadlayer,
) => {
  entityExecutors
  ->Belt.Array.map(({idsToLoad, executor}) => {
    idsToLoad->executor
  })
  ->handleResponses
}

/**Recursively load layers with execute fn composer. Can be used with async or sync functions*/
let rec executeNestedLoadLayersComposer = (
  ~loadLayer,
  ~inMemoryStore,
  //Could be an execution function that is async or sync
  ~executeLoadLayerFn,
  //A call back function, for async or sync
  ~then,
  //Unit value, either wrapped in a promise or not
  ~unit,
) => {
  executeLoadLayerFn(~loadLayer, ~inMemoryStore)->then(res =>
    switch res {
    | LastLayer => unit
    | NextLayer(loadLayer) =>
      executeNestedLoadLayersComposer(~loadLayer, ~inMemoryStore, ~executeLoadLayerFn, ~then, ~unit)
    }
  )
}

/**Load all entities in the entity batch from the db to the inMemoryStore */
let loadEntitiesToInMemStoreComposer = (
  ~entityBatch,
  ~inMemoryStore,
  ~executeLoadLayerFn,
  ~then,
  ~unit,
) => {
  executeNestedLoadLayersComposer(
    ~inMemoryStore,
    ~loadLayer=getLoadLayer(~inMemoryStore, ~entityBatch),
    ~executeLoadLayerFn,
    ~then,
    ~unit,
  )
}

let makeEntityExecuterComposer = (
  ~idsToLoad,
  ~dbReadFn,
  ~inMemStoreSetFn,
  ~store,
  ~getEntiyId,
  ~unit,
  ~then,
) => {
  idsToLoad,
  executor: idsToLoad => {
    switch idsToLoad->Belt.Set.String.toArray {
    | [] => unit //Check if there are values so we don't create an unnecessary empty query
    | idsToLoad =>
      idsToLoad
      ->dbReadFn
      ->then(entities =>
        entities->Belt.Array.forEach(entity => {
          store->inMemStoreSetFn(~key=entity->getEntiyId, ~dbOp=Types.Read, ~entity)
        })
      )
    }
  },
}

/**
Specifically create an sql executor with async functionality
*/
let makeSqlEntityExecuter = (~idsToLoad, ~dbReadFn, ~inMemStoreSetFn, ~store, ~getEntiyId) => {
  makeEntityExecuterComposer(
    ~dbReadFn=DbFunctions.sql->dbReadFn,
    ~idsToLoad,
    ~getEntiyId,
    ~store,
    ~inMemStoreSetFn,
    ~then=Promise.thenResolve,
    ~unit=Promise.resolve(),
  )
}

/**
Executes a single load layer using the async sql functions
*/
let executeSqlLoadLayer = (~loadLayer: LoadLayer.t, ~inMemoryStore: InMemoryStore.t) => {
  let entityExecutors = [
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.eventsSummaryIdsToLoad,
      ~dbReadFn=DbFunctions.EventsSummary.readEntities,
      ~inMemStoreSetFn=InMemoryStore.EventsSummary.set,
      ~store=inMemoryStore.eventsSummary,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.zETA_ApprovalIdsToLoad,
      ~dbReadFn=DbFunctions.ZETA_Approval.readEntities,
      ~inMemStoreSetFn=InMemoryStore.ZETA_Approval.set,
      ~store=inMemoryStore.zETA_Approval,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.zETA_ClaimRewardIdsToLoad,
      ~dbReadFn=DbFunctions.ZETA_ClaimReward.readEntities,
      ~inMemStoreSetFn=InMemoryStore.ZETA_ClaimReward.set,
      ~store=inMemoryStore.zETA_ClaimReward,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.zETA_DepositIdsToLoad,
      ~dbReadFn=DbFunctions.ZETA_Deposit.readEntities,
      ~inMemStoreSetFn=InMemoryStore.ZETA_Deposit.set,
      ~store=inMemoryStore.zETA_Deposit,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.zETA_NewRewardPoolIdsToLoad,
      ~dbReadFn=DbFunctions.ZETA_NewRewardPool.readEntities,
      ~inMemStoreSetFn=InMemoryStore.ZETA_NewRewardPool.set,
      ~store=inMemoryStore.zETA_NewRewardPool,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.zETA_TransferIdsToLoad,
      ~dbReadFn=DbFunctions.ZETA_Transfer.readEntities,
      ~inMemStoreSetFn=InMemoryStore.ZETA_Transfer.set,
      ~store=inMemoryStore.zETA_Transfer,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.zETA_WithdrawalIdsToLoad,
      ~dbReadFn=DbFunctions.ZETA_Withdrawal.readEntities,
      ~inMemStoreSetFn=InMemoryStore.ZETA_Withdrawal.set,
      ~store=inMemoryStore.zETA_Withdrawal,
      ~getEntiyId=entity => entity.id,
    ),
  ]
  let handleResponses = responses => {
    responses
    ->Promise.all
    ->Promise.thenResolve(_ => {
      getNextLayer(~loadLayer)
    })
  }

  executeLoadLayerComposer(~entityExecutors, ~handleResponses)
}

/**Execute loading of entities using sql*/
let loadEntitiesToInMemStore = (~entityBatch, ~inMemoryStore) => {
  loadEntitiesToInMemStoreComposer(
    ~inMemoryStore,
    ~entityBatch,
    ~executeLoadLayerFn=executeSqlLoadLayer,
    ~then=Promise.then,
    ~unit=Promise.resolve(),
  )
}

let executeEntityFunction = (
  sql: Postgres.sql,
  ~rows: array<Types.inMemoryStoreRow<'a>>,
  ~dbOp: Types.dbOp,
  ~dbFunction: (Postgres.sql, array<'b>) => promise<unit>,
  ~getInputValFromRow: Types.inMemoryStoreRow<'a> => 'b,
) => {
  let entityIds =
    rows->Belt.Array.keepMap(row => row.dbOp == dbOp ? Some(row->getInputValFromRow) : None)

  if entityIds->Array.length > 0 {
    sql->dbFunction(entityIds)
  } else {
    Promise.resolve()
  }
}

let executeSet = executeEntityFunction(~dbOp=Set)
let executeDelete = executeEntityFunction(~dbOp=Delete)

let executeSetSchemaEntity = (~entityEncoder) =>
  executeSet(~getInputValFromRow=row => {
    row.entity->entityEncoder
  })

let executeBatch = async (sql, ~inMemoryStore: InMemoryStore.t) => {
  let setEventSyncState = executeSet(
    ~dbFunction=DbFunctions.EventSyncState.batchSet,
    ~getInputValFromRow=row => row.entity,
    ~rows=inMemoryStore.eventSyncState->InMemoryStore.EventSyncState.values,
  )

  let setRawEvents = executeSet(
    ~dbFunction=DbFunctions.RawEvents.batchSet,
    ~getInputValFromRow=row => row.entity,
    ~rows=inMemoryStore.rawEvents->InMemoryStore.RawEvents.values,
  )

  let setDynamicContracts = executeSet(
    ~dbFunction=DbFunctions.DynamicContractRegistry.batchSet,
    ~rows=inMemoryStore.dynamicContractRegistry->InMemoryStore.DynamicContractRegistry.values,
    ~getInputValFromRow={row => row.entity},
  )

  let deleteEventsSummarys = executeDelete(
    ~dbFunction=DbFunctions.EventsSummary.batchDelete,
    ~rows=inMemoryStore.eventsSummary->InMemoryStore.EventsSummary.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setEventsSummarys = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.EventsSummary.batchSet,
    ~rows=inMemoryStore.eventsSummary->InMemoryStore.EventsSummary.values,
    ~entityEncoder=Types.eventsSummaryEntity_encode,
  )

  let deleteZETA_Approvals = executeDelete(
    ~dbFunction=DbFunctions.ZETA_Approval.batchDelete,
    ~rows=inMemoryStore.zETA_Approval->InMemoryStore.ZETA_Approval.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setZETA_Approvals = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.ZETA_Approval.batchSet,
    ~rows=inMemoryStore.zETA_Approval->InMemoryStore.ZETA_Approval.values,
    ~entityEncoder=Types.zETA_ApprovalEntity_encode,
  )

  let deleteZETA_ClaimRewards = executeDelete(
    ~dbFunction=DbFunctions.ZETA_ClaimReward.batchDelete,
    ~rows=inMemoryStore.zETA_ClaimReward->InMemoryStore.ZETA_ClaimReward.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setZETA_ClaimRewards = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.ZETA_ClaimReward.batchSet,
    ~rows=inMemoryStore.zETA_ClaimReward->InMemoryStore.ZETA_ClaimReward.values,
    ~entityEncoder=Types.zETA_ClaimRewardEntity_encode,
  )

  let deleteZETA_Deposits = executeDelete(
    ~dbFunction=DbFunctions.ZETA_Deposit.batchDelete,
    ~rows=inMemoryStore.zETA_Deposit->InMemoryStore.ZETA_Deposit.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setZETA_Deposits = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.ZETA_Deposit.batchSet,
    ~rows=inMemoryStore.zETA_Deposit->InMemoryStore.ZETA_Deposit.values,
    ~entityEncoder=Types.zETA_DepositEntity_encode,
  )

  let deleteZETA_NewRewardPools = executeDelete(
    ~dbFunction=DbFunctions.ZETA_NewRewardPool.batchDelete,
    ~rows=inMemoryStore.zETA_NewRewardPool->InMemoryStore.ZETA_NewRewardPool.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setZETA_NewRewardPools = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.ZETA_NewRewardPool.batchSet,
    ~rows=inMemoryStore.zETA_NewRewardPool->InMemoryStore.ZETA_NewRewardPool.values,
    ~entityEncoder=Types.zETA_NewRewardPoolEntity_encode,
  )

  let deleteZETA_Transfers = executeDelete(
    ~dbFunction=DbFunctions.ZETA_Transfer.batchDelete,
    ~rows=inMemoryStore.zETA_Transfer->InMemoryStore.ZETA_Transfer.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setZETA_Transfers = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.ZETA_Transfer.batchSet,
    ~rows=inMemoryStore.zETA_Transfer->InMemoryStore.ZETA_Transfer.values,
    ~entityEncoder=Types.zETA_TransferEntity_encode,
  )

  let deleteZETA_Withdrawals = executeDelete(
    ~dbFunction=DbFunctions.ZETA_Withdrawal.batchDelete,
    ~rows=inMemoryStore.zETA_Withdrawal->InMemoryStore.ZETA_Withdrawal.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setZETA_Withdrawals = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.ZETA_Withdrawal.batchSet,
    ~rows=inMemoryStore.zETA_Withdrawal->InMemoryStore.ZETA_Withdrawal.values,
    ~entityEncoder=Types.zETA_WithdrawalEntity_encode,
  )

  let res = await sql->Postgres.beginSql(sql => {
    [
      setEventSyncState,
      setRawEvents,
      setDynamicContracts,
      deleteEventsSummarys,
      setEventsSummarys,
      deleteZETA_Approvals,
      setZETA_Approvals,
      deleteZETA_ClaimRewards,
      setZETA_ClaimRewards,
      deleteZETA_Deposits,
      setZETA_Deposits,
      deleteZETA_NewRewardPools,
      setZETA_NewRewardPools,
      deleteZETA_Transfers,
      setZETA_Transfers,
      deleteZETA_Withdrawals,
      setZETA_Withdrawals,
    ]->Belt.Array.map(dbFunc => sql->dbFunc)
  })

  res
}
