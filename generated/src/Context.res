type entityGetters = {
  getEventsSummary: Types.id => promise<array<Types.eventsSummaryEntity>>,
  getZETA_Approval: Types.id => promise<array<Types.zETA_ApprovalEntity>>,
  getZETA_ClaimReward: Types.id => promise<array<Types.zETA_ClaimRewardEntity>>,
  getZETA_Deposit: Types.id => promise<array<Types.zETA_DepositEntity>>,
  getZETA_NewRewardPool: Types.id => promise<array<Types.zETA_NewRewardPoolEntity>>,
  getZETA_Transfer: Types.id => promise<array<Types.zETA_TransferEntity>>,
  getZETA_Withdrawal: Types.id => promise<array<Types.zETA_WithdrawalEntity>>,
}

@genType
type genericContextCreatorFunctions<'loaderContext, 'handlerContextSync, 'handlerContextAsync> = {
  log: Logs.userLogger,
  getLoaderContext: unit => 'loaderContext,
  getHandlerContextSync: unit => 'handlerContextSync,
  getHandlerContextAsync: unit => 'handlerContextAsync,
  getEntitiesToLoad: unit => array<Types.entityRead>,
  getAddedDynamicContractRegistrations: unit => array<Types.dynamicContractRegistryEntity>,
}

type contextCreator<'eventArgs, 'loaderContext, 'handlerContext, 'handlerContextAsync> = (
  ~inMemoryStore: IO.InMemoryStore.t,
  ~chainId: int,
  ~event: Types.eventLog<'eventArgs>,
  ~logger: Pino.t,
  ~asyncGetters: entityGetters,
) => genericContextCreatorFunctions<'loaderContext, 'handlerContext, 'handlerContextAsync>

exception UnableToLoadNonNullableLinkedEntity(string)
exception LinkedEntityNotAvailableInSyncHandler(string)

module ZETAContract = {
  module ApprovalEvent = {
    type loaderContext = Types.ZETAContract.ApprovalEvent.loaderContext
    type handlerContext = Types.ZETAContract.ApprovalEvent.handlerContext
    type handlerContextAsync = Types.ZETAContract.ApprovalEvent.handlerContextAsync
    type context = genericContextCreatorFunctions<
      loaderContext,
      handlerContext,
      handlerContextAsync,
    >

    let contextCreator: contextCreator<
      Types.ZETAContract.ApprovalEvent.eventArgs,
      loaderContext,
      handlerContext,
      handlerContextAsync,
    > = (~inMemoryStore, ~chainId, ~event, ~logger, ~asyncGetters) => {
      // NOTE: we could optimise this code to onle create a logger if there was a log called.
      let logger = logger->Logging.createChildFrom(
        ~logger=_,
        ~params={
          "context": "ZETA.Approval",
          "chainId": chainId,
          "block": event.blockNumber,
          "logIndex": event.logIndex,
          "txHash": event.transactionHash,
        },
      )

      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Approval: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_ClaimReward: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Deposit: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_NewRewardPool: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Transfer: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Withdrawal: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addZETA: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "ZETA",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
        zETA_Approval: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Approval->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ApprovalRead(id))
          },
        },
        zETA_ClaimReward: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_ClaimReward->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ClaimRewardRead(id))
          },
        },
        zETA_Deposit: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Deposit->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_DepositRead(id))
          },
        },
        zETA_NewRewardPool: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_NewRewardPool->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_NewRewardPoolRead(id))
          },
        },
        zETA_Transfer: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Transfer->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_TransferRead(id))
          },
        },
        zETA_Withdrawal: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Withdrawal->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_WithdrawalRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContextSync: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Approval" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Approval.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_ClaimReward" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_ClaimReward.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Deposit" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Deposit.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_NewRewardPool" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_NewRewardPool.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Transfer" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Transfer.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Withdrawal" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Withdrawal.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
        }
      }

      let getHandlerContextAsync = (): handlerContextAsync => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getEventsSummary(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.EventsSummary.set(
                      inMemoryStore.eventsSummary,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Approval(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Approval.set(
                      inMemoryStore.zETA_Approval,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_ClaimReward(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_ClaimReward.set(
                      inMemoryStore.zETA_ClaimReward,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Deposit(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Deposit.set(
                      inMemoryStore.zETA_Deposit,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(
                  id,
                ) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_NewRewardPool(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_NewRewardPool.set(
                      inMemoryStore.zETA_NewRewardPool,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Transfer(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Transfer.set(
                      inMemoryStore.zETA_Transfer,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Withdrawal(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Withdrawal.set(
                      inMemoryStore.zETA_Withdrawal,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
        }
      }

      {
        log: contextLogger,
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContextSync,
        getHandlerContextAsync,
      }
    }
  }

  module ClaimRewardEvent = {
    type loaderContext = Types.ZETAContract.ClaimRewardEvent.loaderContext
    type handlerContext = Types.ZETAContract.ClaimRewardEvent.handlerContext
    type handlerContextAsync = Types.ZETAContract.ClaimRewardEvent.handlerContextAsync
    type context = genericContextCreatorFunctions<
      loaderContext,
      handlerContext,
      handlerContextAsync,
    >

    let contextCreator: contextCreator<
      Types.ZETAContract.ClaimRewardEvent.eventArgs,
      loaderContext,
      handlerContext,
      handlerContextAsync,
    > = (~inMemoryStore, ~chainId, ~event, ~logger, ~asyncGetters) => {
      // NOTE: we could optimise this code to onle create a logger if there was a log called.
      let logger = logger->Logging.createChildFrom(
        ~logger=_,
        ~params={
          "context": "ZETA.ClaimReward",
          "chainId": chainId,
          "block": event.blockNumber,
          "logIndex": event.logIndex,
          "txHash": event.transactionHash,
        },
      )

      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Approval: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_ClaimReward: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Deposit: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_NewRewardPool: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Transfer: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Withdrawal: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addZETA: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "ZETA",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
        zETA_Approval: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Approval->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ApprovalRead(id))
          },
        },
        zETA_ClaimReward: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_ClaimReward->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ClaimRewardRead(id))
          },
        },
        zETA_Deposit: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Deposit->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_DepositRead(id))
          },
        },
        zETA_NewRewardPool: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_NewRewardPool->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_NewRewardPoolRead(id))
          },
        },
        zETA_Transfer: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Transfer->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_TransferRead(id))
          },
        },
        zETA_Withdrawal: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Withdrawal->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_WithdrawalRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContextSync: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Approval" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Approval.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_ClaimReward" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_ClaimReward.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Deposit" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Deposit.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_NewRewardPool" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_NewRewardPool.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Transfer" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Transfer.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Withdrawal" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Withdrawal.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
        }
      }

      let getHandlerContextAsync = (): handlerContextAsync => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getEventsSummary(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.EventsSummary.set(
                      inMemoryStore.eventsSummary,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Approval(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Approval.set(
                      inMemoryStore.zETA_Approval,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_ClaimReward(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_ClaimReward.set(
                      inMemoryStore.zETA_ClaimReward,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Deposit(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Deposit.set(
                      inMemoryStore.zETA_Deposit,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(
                  id,
                ) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_NewRewardPool(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_NewRewardPool.set(
                      inMemoryStore.zETA_NewRewardPool,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Transfer(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Transfer.set(
                      inMemoryStore.zETA_Transfer,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Withdrawal(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Withdrawal.set(
                      inMemoryStore.zETA_Withdrawal,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
        }
      }

      {
        log: contextLogger,
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContextSync,
        getHandlerContextAsync,
      }
    }
  }

  module DepositEvent = {
    type loaderContext = Types.ZETAContract.DepositEvent.loaderContext
    type handlerContext = Types.ZETAContract.DepositEvent.handlerContext
    type handlerContextAsync = Types.ZETAContract.DepositEvent.handlerContextAsync
    type context = genericContextCreatorFunctions<
      loaderContext,
      handlerContext,
      handlerContextAsync,
    >

    let contextCreator: contextCreator<
      Types.ZETAContract.DepositEvent.eventArgs,
      loaderContext,
      handlerContext,
      handlerContextAsync,
    > = (~inMemoryStore, ~chainId, ~event, ~logger, ~asyncGetters) => {
      // NOTE: we could optimise this code to onle create a logger if there was a log called.
      let logger = logger->Logging.createChildFrom(
        ~logger=_,
        ~params={
          "context": "ZETA.Deposit",
          "chainId": chainId,
          "block": event.blockNumber,
          "logIndex": event.logIndex,
          "txHash": event.transactionHash,
        },
      )

      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Approval: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_ClaimReward: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Deposit: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_NewRewardPool: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Transfer: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Withdrawal: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addZETA: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "ZETA",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
        zETA_Approval: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Approval->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ApprovalRead(id))
          },
        },
        zETA_ClaimReward: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_ClaimReward->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ClaimRewardRead(id))
          },
        },
        zETA_Deposit: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Deposit->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_DepositRead(id))
          },
        },
        zETA_NewRewardPool: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_NewRewardPool->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_NewRewardPoolRead(id))
          },
        },
        zETA_Transfer: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Transfer->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_TransferRead(id))
          },
        },
        zETA_Withdrawal: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Withdrawal->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_WithdrawalRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContextSync: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Approval" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Approval.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_ClaimReward" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_ClaimReward.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Deposit" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Deposit.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_NewRewardPool" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_NewRewardPool.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Transfer" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Transfer.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Withdrawal" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Withdrawal.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
        }
      }

      let getHandlerContextAsync = (): handlerContextAsync => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getEventsSummary(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.EventsSummary.set(
                      inMemoryStore.eventsSummary,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Approval(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Approval.set(
                      inMemoryStore.zETA_Approval,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_ClaimReward(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_ClaimReward.set(
                      inMemoryStore.zETA_ClaimReward,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Deposit(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Deposit.set(
                      inMemoryStore.zETA_Deposit,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(
                  id,
                ) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_NewRewardPool(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_NewRewardPool.set(
                      inMemoryStore.zETA_NewRewardPool,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Transfer(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Transfer.set(
                      inMemoryStore.zETA_Transfer,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Withdrawal(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Withdrawal.set(
                      inMemoryStore.zETA_Withdrawal,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
        }
      }

      {
        log: contextLogger,
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContextSync,
        getHandlerContextAsync,
      }
    }
  }

  module NewRewardPoolEvent = {
    type loaderContext = Types.ZETAContract.NewRewardPoolEvent.loaderContext
    type handlerContext = Types.ZETAContract.NewRewardPoolEvent.handlerContext
    type handlerContextAsync = Types.ZETAContract.NewRewardPoolEvent.handlerContextAsync
    type context = genericContextCreatorFunctions<
      loaderContext,
      handlerContext,
      handlerContextAsync,
    >

    let contextCreator: contextCreator<
      Types.ZETAContract.NewRewardPoolEvent.eventArgs,
      loaderContext,
      handlerContext,
      handlerContextAsync,
    > = (~inMemoryStore, ~chainId, ~event, ~logger, ~asyncGetters) => {
      // NOTE: we could optimise this code to onle create a logger if there was a log called.
      let logger = logger->Logging.createChildFrom(
        ~logger=_,
        ~params={
          "context": "ZETA.NewRewardPool",
          "chainId": chainId,
          "block": event.blockNumber,
          "logIndex": event.logIndex,
          "txHash": event.transactionHash,
        },
      )

      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Approval: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_ClaimReward: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Deposit: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_NewRewardPool: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Transfer: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Withdrawal: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addZETA: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "ZETA",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
        zETA_Approval: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Approval->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ApprovalRead(id))
          },
        },
        zETA_ClaimReward: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_ClaimReward->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ClaimRewardRead(id))
          },
        },
        zETA_Deposit: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Deposit->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_DepositRead(id))
          },
        },
        zETA_NewRewardPool: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_NewRewardPool->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_NewRewardPoolRead(id))
          },
        },
        zETA_Transfer: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Transfer->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_TransferRead(id))
          },
        },
        zETA_Withdrawal: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Withdrawal->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_WithdrawalRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContextSync: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Approval" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Approval.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_ClaimReward" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_ClaimReward.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Deposit" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Deposit.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_NewRewardPool" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_NewRewardPool.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Transfer" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Transfer.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Withdrawal" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Withdrawal.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
        }
      }

      let getHandlerContextAsync = (): handlerContextAsync => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getEventsSummary(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.EventsSummary.set(
                      inMemoryStore.eventsSummary,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Approval(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Approval.set(
                      inMemoryStore.zETA_Approval,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_ClaimReward(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_ClaimReward.set(
                      inMemoryStore.zETA_ClaimReward,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Deposit(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Deposit.set(
                      inMemoryStore.zETA_Deposit,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(
                  id,
                ) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_NewRewardPool(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_NewRewardPool.set(
                      inMemoryStore.zETA_NewRewardPool,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Transfer(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Transfer.set(
                      inMemoryStore.zETA_Transfer,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Withdrawal(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Withdrawal.set(
                      inMemoryStore.zETA_Withdrawal,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
        }
      }

      {
        log: contextLogger,
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContextSync,
        getHandlerContextAsync,
      }
    }
  }

  module TransferEvent = {
    type loaderContext = Types.ZETAContract.TransferEvent.loaderContext
    type handlerContext = Types.ZETAContract.TransferEvent.handlerContext
    type handlerContextAsync = Types.ZETAContract.TransferEvent.handlerContextAsync
    type context = genericContextCreatorFunctions<
      loaderContext,
      handlerContext,
      handlerContextAsync,
    >

    let contextCreator: contextCreator<
      Types.ZETAContract.TransferEvent.eventArgs,
      loaderContext,
      handlerContext,
      handlerContextAsync,
    > = (~inMemoryStore, ~chainId, ~event, ~logger, ~asyncGetters) => {
      // NOTE: we could optimise this code to onle create a logger if there was a log called.
      let logger = logger->Logging.createChildFrom(
        ~logger=_,
        ~params={
          "context": "ZETA.Transfer",
          "chainId": chainId,
          "block": event.blockNumber,
          "logIndex": event.logIndex,
          "txHash": event.transactionHash,
        },
      )

      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Approval: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_ClaimReward: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Deposit: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_NewRewardPool: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Transfer: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Withdrawal: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addZETA: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "ZETA",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
        zETA_Approval: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Approval->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ApprovalRead(id))
          },
        },
        zETA_ClaimReward: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_ClaimReward->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ClaimRewardRead(id))
          },
        },
        zETA_Deposit: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Deposit->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_DepositRead(id))
          },
        },
        zETA_NewRewardPool: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_NewRewardPool->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_NewRewardPoolRead(id))
          },
        },
        zETA_Transfer: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Transfer->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_TransferRead(id))
          },
        },
        zETA_Withdrawal: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Withdrawal->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_WithdrawalRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContextSync: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Approval" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Approval.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_ClaimReward" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_ClaimReward.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Deposit" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Deposit.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_NewRewardPool" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_NewRewardPool.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Transfer" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Transfer.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Withdrawal" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Withdrawal.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
        }
      }

      let getHandlerContextAsync = (): handlerContextAsync => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getEventsSummary(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.EventsSummary.set(
                      inMemoryStore.eventsSummary,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Approval(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Approval.set(
                      inMemoryStore.zETA_Approval,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_ClaimReward(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_ClaimReward.set(
                      inMemoryStore.zETA_ClaimReward,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Deposit(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Deposit.set(
                      inMemoryStore.zETA_Deposit,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(
                  id,
                ) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_NewRewardPool(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_NewRewardPool.set(
                      inMemoryStore.zETA_NewRewardPool,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Transfer(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Transfer.set(
                      inMemoryStore.zETA_Transfer,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Withdrawal(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Withdrawal.set(
                      inMemoryStore.zETA_Withdrawal,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
        }
      }

      {
        log: contextLogger,
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContextSync,
        getHandlerContextAsync,
      }
    }
  }

  module WithdrawalEvent = {
    type loaderContext = Types.ZETAContract.WithdrawalEvent.loaderContext
    type handlerContext = Types.ZETAContract.WithdrawalEvent.handlerContext
    type handlerContextAsync = Types.ZETAContract.WithdrawalEvent.handlerContextAsync
    type context = genericContextCreatorFunctions<
      loaderContext,
      handlerContext,
      handlerContextAsync,
    >

    let contextCreator: contextCreator<
      Types.ZETAContract.WithdrawalEvent.eventArgs,
      loaderContext,
      handlerContext,
      handlerContextAsync,
    > = (~inMemoryStore, ~chainId, ~event, ~logger, ~asyncGetters) => {
      // NOTE: we could optimise this code to onle create a logger if there was a log called.
      let logger = logger->Logging.createChildFrom(
        ~logger=_,
        ~params={
          "context": "ZETA.Withdrawal",
          "chainId": chainId,
          "block": event.blockNumber,
          "logIndex": event.logIndex,
          "txHash": event.transactionHash,
        },
      )

      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Approval: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_ClaimReward: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Deposit: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_NewRewardPool: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Transfer: Set.t<Types.id> = Set.make()
      let optSetOfIds_zETA_Withdrawal: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addZETA: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "ZETA",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
        zETA_Approval: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Approval->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ApprovalRead(id))
          },
        },
        zETA_ClaimReward: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_ClaimReward->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_ClaimRewardRead(id))
          },
        },
        zETA_Deposit: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Deposit->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_DepositRead(id))
          },
        },
        zETA_NewRewardPool: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_NewRewardPool->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_NewRewardPoolRead(id))
          },
        },
        zETA_Transfer: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Transfer->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_TransferRead(id))
          },
        },
        zETA_Withdrawal: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_zETA_Withdrawal->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.ZETA_WithdrawalRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContextSync: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Approval" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Approval.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_ClaimReward" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_ClaimReward.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Deposit" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Deposit.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_NewRewardPool" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_NewRewardPool.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Transfer" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Transfer.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                Logging.warn(
                  `The loader for a "ZETA_Withdrawal" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.zETA_Withdrawal.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
        }
      }

      let getHandlerContextAsync = (): handlerContextAsync => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getEventsSummary(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.EventsSummary.set(
                      inMemoryStore.eventsSummary,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Approval: {
            set: entity => {
              inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Approval) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Approval->Set.has(id) {
                inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Approval->IO.InMemoryStore.ZETA_Approval.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Approval(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Approval.set(
                      inMemoryStore.zETA_Approval,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_ClaimReward: {
            set: entity => {
              inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_ClaimReward) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_ClaimReward->Set.has(id) {
                inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_ClaimReward->IO.InMemoryStore.ZETA_ClaimReward.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_ClaimReward(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_ClaimReward.set(
                      inMemoryStore.zETA_ClaimReward,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Deposit: {
            set: entity => {
              inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Deposit) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Deposit->Set.has(id) {
                inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Deposit->IO.InMemoryStore.ZETA_Deposit.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Deposit(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Deposit.set(
                      inMemoryStore.zETA_Deposit,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_NewRewardPool: {
            set: entity => {
              inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_NewRewardPool) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_NewRewardPool->Set.has(id) {
                inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_NewRewardPool->IO.InMemoryStore.ZETA_NewRewardPool.get(
                  id,
                ) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_NewRewardPool(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_NewRewardPool.set(
                      inMemoryStore.zETA_NewRewardPool,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Transfer: {
            set: entity => {
              inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Transfer) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Transfer->Set.has(id) {
                inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Transfer->IO.InMemoryStore.ZETA_Transfer.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Transfer(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Transfer.set(
                      inMemoryStore.zETA_Transfer,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
          zETA_Withdrawal: {
            set: entity => {
              inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(zETA_Withdrawal) with ID ${id}.`,
              ),
            get: async (id: Types.id) => {
              if optSetOfIds_zETA_Withdrawal->Set.has(id) {
                inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id)
              } else {
                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                switch inMemoryStore.zETA_Withdrawal->IO.InMemoryStore.ZETA_Withdrawal.get(id) {
                | Some(entity) => Some(entity)
                | None =>
                  let entities = await asyncGetters.getZETA_Withdrawal(id)

                  switch entities->Belt.Array.get(0) {
                  | Some(entity) =>
                    // TODO: make this work with the test framework too.
                    IO.InMemoryStore.ZETA_Withdrawal.set(
                      inMemoryStore.zETA_Withdrawal,
                      ~key=entity.id,
                      ~dbOp=Types.Read,
                      ~entity,
                    )
                    Some(entity)
                  | None => None
                  }
                }
              }
            },
          },
        }
      }

      {
        log: contextLogger,
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContextSync,
        getHandlerContextAsync,
      }
    }
  }
}

@deriving(accessors)
type eventAndContext =
  | ZETAContract_ApprovalWithContext(
      Types.eventLog<Types.ZETAContract.ApprovalEvent.eventArgs>,
      ZETAContract.ApprovalEvent.context,
    )
  | ZETAContract_ClaimRewardWithContext(
      Types.eventLog<Types.ZETAContract.ClaimRewardEvent.eventArgs>,
      ZETAContract.ClaimRewardEvent.context,
    )
  | ZETAContract_DepositWithContext(
      Types.eventLog<Types.ZETAContract.DepositEvent.eventArgs>,
      ZETAContract.DepositEvent.context,
    )
  | ZETAContract_NewRewardPoolWithContext(
      Types.eventLog<Types.ZETAContract.NewRewardPoolEvent.eventArgs>,
      ZETAContract.NewRewardPoolEvent.context,
    )
  | ZETAContract_TransferWithContext(
      Types.eventLog<Types.ZETAContract.TransferEvent.eventArgs>,
      ZETAContract.TransferEvent.context,
    )
  | ZETAContract_WithdrawalWithContext(
      Types.eventLog<Types.ZETAContract.WithdrawalEvent.eventArgs>,
      ZETAContract.WithdrawalEvent.context,
    )

type eventRouterEventAndContext = {
  chainId: int,
  event: eventAndContext,
}
