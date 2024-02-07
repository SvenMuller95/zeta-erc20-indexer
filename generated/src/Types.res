//*************
//***ENTITIES**
//*************

@spice @genType.as("Id")
type id = string

@genType.import(("./bindings/OpaqueTypes", "Nullable"))
type nullable<'a> = option<'a>

let nullable_encode = (encoder: Spice.encoder<'a>, n: nullable<'a>): Js.Json.t =>
  switch n {
  | None => Js.Json.null
  | Some(v) => v->encoder
  }

let nullable_decode = Spice.optionFromJson

@@warning("-30")
@genType
type rec eventsSummaryLoaderConfig = bool
and zETA_ApprovalLoaderConfig = bool
and zETA_ClaimRewardLoaderConfig = bool
and zETA_DepositLoaderConfig = bool
and zETA_NewRewardPoolLoaderConfig = bool
and zETA_TransferLoaderConfig = bool
and zETA_WithdrawalLoaderConfig = bool

@@warning("+30")
@genType
type entityRead =
  | EventsSummaryRead(id)
  | ZETA_ApprovalRead(id)
  | ZETA_ClaimRewardRead(id)
  | ZETA_DepositRead(id)
  | ZETA_NewRewardPoolRead(id)
  | ZETA_TransferRead(id)
  | ZETA_WithdrawalRead(id)

@genType
type rawEventsEntity = {
  @as("chain_id") chainId: int,
  @as("event_id") eventId: string,
  @as("block_number") blockNumber: int,
  @as("log_index") logIndex: int,
  @as("transaction_index") transactionIndex: int,
  @as("transaction_hash") transactionHash: string,
  @as("src_address") srcAddress: Ethers.ethAddress,
  @as("block_hash") blockHash: string,
  @as("block_timestamp") blockTimestamp: int,
  @as("event_type") eventType: Js.Json.t,
  params: string,
}

@genType
type dynamicContractRegistryEntity = {
  @as("chain_id") chainId: int,
  @as("event_id") eventId: Ethers.BigInt.t,
  @as("contract_address") contractAddress: Ethers.ethAddress,
  @as("contract_type") contractType: string,
}

@spice @genType.as("EventsSummaryEntity")
type eventsSummaryEntity = {
  id: id,
  zETA_ApprovalCount: Ethers.BigInt.t,
  zETA_ClaimRewardCount: Ethers.BigInt.t,
  zETA_DepositCount: Ethers.BigInt.t,
  zETA_NewRewardPoolCount: Ethers.BigInt.t,
  zETA_TransferCount: Ethers.BigInt.t,
  zETA_WithdrawalCount: Ethers.BigInt.t,
}

@spice @genType.as("ZETA_ApprovalEntity")
type zETA_ApprovalEntity = {
  id: id,
  owner: string,
  spender: string,
  value: Ethers.BigInt.t,
  eventsSummary: string,
}

@spice @genType.as("ZETA_ClaimRewardEntity")
type zETA_ClaimRewardEntity = {
  id: id,
  account: string,
  idx: Ethers.BigInt.t,
  amount: Ethers.BigInt.t,
  eventsSummary: string,
}

@spice @genType.as("ZETA_DepositEntity")
type zETA_DepositEntity = {
  id: id,
  account: string,
  idx: Ethers.BigInt.t,
  amount: Ethers.BigInt.t,
  eventsSummary: string,
}

@spice @genType.as("ZETA_NewRewardPoolEntity")
type zETA_NewRewardPoolEntity = {
  id: id,
  rewardPool: string,
  eventsSummary: string,
}

@spice @genType.as("ZETA_TransferEntity")
type zETA_TransferEntity = {
  id: id,
  from: string,
  to: string,
  value: Ethers.BigInt.t,
  eventsSummary: string,
}

@spice @genType.as("ZETA_WithdrawalEntity")
type zETA_WithdrawalEntity = {
  id: id,
  account: string,
  idx: Ethers.BigInt.t,
  amount: Ethers.BigInt.t,
  eventsSummary: string,
}

type entity =
  | EventsSummaryEntity(eventsSummaryEntity)
  | ZETA_ApprovalEntity(zETA_ApprovalEntity)
  | ZETA_ClaimRewardEntity(zETA_ClaimRewardEntity)
  | ZETA_DepositEntity(zETA_DepositEntity)
  | ZETA_NewRewardPoolEntity(zETA_NewRewardPoolEntity)
  | ZETA_TransferEntity(zETA_TransferEntity)
  | ZETA_WithdrawalEntity(zETA_WithdrawalEntity)

type dbOp = Read | Set | Delete

type inMemoryStoreRow<'a> = {
  dbOp: dbOp,
  entity: 'a,
}

//*************
//**CONTRACTS**
//*************

@genType.as("EventLog")
type eventLog<'a> = {
  params: 'a,
  chainId: int,
  blockNumber: int,
  blockTimestamp: int,
  blockHash: string,
  srcAddress: Ethers.ethAddress,
  transactionHash: string,
  transactionIndex: int,
  logIndex: int,
}

module ZETAContract = {
  module ApprovalEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") owner: Ethers.ethAddress,
      @as("1") spender: Ethers.ethAddress,
      @as("2") value: Ethers.BigInt.t,
    }

    @spice @genType
    type eventArgs = {
      owner: Ethers.ethAddress,
      spender: Ethers.ethAddress,
      value: Ethers.BigInt.t,
    }

    @genType.as("ZETAContract_Approval_EventLog")
    type log = eventLog<eventArgs>

    // Entity: EventsSummary
    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    type eventsSummaryEntityHandlerContextAsync = {
      get: id => promise<option<eventsSummaryEntity>>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Approval
    type zETA_ApprovalEntityHandlerContext = {
      get: id => option<zETA_ApprovalEntity>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    type zETA_ApprovalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ApprovalEntity>>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_ClaimReward
    type zETA_ClaimRewardEntityHandlerContext = {
      get: id => option<zETA_ClaimRewardEntity>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    type zETA_ClaimRewardEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ClaimRewardEntity>>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Deposit
    type zETA_DepositEntityHandlerContext = {
      get: id => option<zETA_DepositEntity>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    type zETA_DepositEntityHandlerContextAsync = {
      get: id => promise<option<zETA_DepositEntity>>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_NewRewardPool
    type zETA_NewRewardPoolEntityHandlerContext = {
      get: id => option<zETA_NewRewardPoolEntity>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    type zETA_NewRewardPoolEntityHandlerContextAsync = {
      get: id => promise<option<zETA_NewRewardPoolEntity>>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Transfer
    type zETA_TransferEntityHandlerContext = {
      get: id => option<zETA_TransferEntity>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    type zETA_TransferEntityHandlerContextAsync = {
      get: id => promise<option<zETA_TransferEntity>>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Withdrawal
    type zETA_WithdrawalEntityHandlerContext = {
      get: id => option<zETA_WithdrawalEntity>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    type zETA_WithdrawalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_WithdrawalEntity>>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContext,
    }
    @genType
    type handlerContextAsync = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContextAsync,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContextAsync,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContextAsync,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContextAsync,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContextAsync,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContextAsync,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContextAsync,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ApprovalEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ClaimRewardEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_DepositEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_NewRewardPoolEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_TransferEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_WithdrawalEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addZETA: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityLoaderContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityLoaderContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityLoaderContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityLoaderContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityLoaderContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityLoaderContext,
    }
  }
  module ClaimRewardEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") account: Ethers.ethAddress,
      @as("1") idx: Ethers.BigInt.t,
      @as("2") amount: Ethers.BigInt.t,
    }

    @spice @genType
    type eventArgs = {
      account: Ethers.ethAddress,
      idx: Ethers.BigInt.t,
      amount: Ethers.BigInt.t,
    }

    @genType.as("ZETAContract_ClaimReward_EventLog")
    type log = eventLog<eventArgs>

    // Entity: EventsSummary
    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    type eventsSummaryEntityHandlerContextAsync = {
      get: id => promise<option<eventsSummaryEntity>>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Approval
    type zETA_ApprovalEntityHandlerContext = {
      get: id => option<zETA_ApprovalEntity>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    type zETA_ApprovalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ApprovalEntity>>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_ClaimReward
    type zETA_ClaimRewardEntityHandlerContext = {
      get: id => option<zETA_ClaimRewardEntity>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    type zETA_ClaimRewardEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ClaimRewardEntity>>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Deposit
    type zETA_DepositEntityHandlerContext = {
      get: id => option<zETA_DepositEntity>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    type zETA_DepositEntityHandlerContextAsync = {
      get: id => promise<option<zETA_DepositEntity>>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_NewRewardPool
    type zETA_NewRewardPoolEntityHandlerContext = {
      get: id => option<zETA_NewRewardPoolEntity>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    type zETA_NewRewardPoolEntityHandlerContextAsync = {
      get: id => promise<option<zETA_NewRewardPoolEntity>>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Transfer
    type zETA_TransferEntityHandlerContext = {
      get: id => option<zETA_TransferEntity>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    type zETA_TransferEntityHandlerContextAsync = {
      get: id => promise<option<zETA_TransferEntity>>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Withdrawal
    type zETA_WithdrawalEntityHandlerContext = {
      get: id => option<zETA_WithdrawalEntity>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    type zETA_WithdrawalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_WithdrawalEntity>>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContext,
    }
    @genType
    type handlerContextAsync = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContextAsync,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContextAsync,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContextAsync,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContextAsync,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContextAsync,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContextAsync,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContextAsync,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ApprovalEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ClaimRewardEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_DepositEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_NewRewardPoolEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_TransferEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_WithdrawalEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addZETA: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityLoaderContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityLoaderContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityLoaderContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityLoaderContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityLoaderContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityLoaderContext,
    }
  }
  module DepositEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") account: Ethers.ethAddress,
      @as("1") idx: Ethers.BigInt.t,
      @as("2") amount: Ethers.BigInt.t,
    }

    @spice @genType
    type eventArgs = {
      account: Ethers.ethAddress,
      idx: Ethers.BigInt.t,
      amount: Ethers.BigInt.t,
    }

    @genType.as("ZETAContract_Deposit_EventLog")
    type log = eventLog<eventArgs>

    // Entity: EventsSummary
    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    type eventsSummaryEntityHandlerContextAsync = {
      get: id => promise<option<eventsSummaryEntity>>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Approval
    type zETA_ApprovalEntityHandlerContext = {
      get: id => option<zETA_ApprovalEntity>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    type zETA_ApprovalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ApprovalEntity>>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_ClaimReward
    type zETA_ClaimRewardEntityHandlerContext = {
      get: id => option<zETA_ClaimRewardEntity>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    type zETA_ClaimRewardEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ClaimRewardEntity>>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Deposit
    type zETA_DepositEntityHandlerContext = {
      get: id => option<zETA_DepositEntity>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    type zETA_DepositEntityHandlerContextAsync = {
      get: id => promise<option<zETA_DepositEntity>>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_NewRewardPool
    type zETA_NewRewardPoolEntityHandlerContext = {
      get: id => option<zETA_NewRewardPoolEntity>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    type zETA_NewRewardPoolEntityHandlerContextAsync = {
      get: id => promise<option<zETA_NewRewardPoolEntity>>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Transfer
    type zETA_TransferEntityHandlerContext = {
      get: id => option<zETA_TransferEntity>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    type zETA_TransferEntityHandlerContextAsync = {
      get: id => promise<option<zETA_TransferEntity>>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Withdrawal
    type zETA_WithdrawalEntityHandlerContext = {
      get: id => option<zETA_WithdrawalEntity>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    type zETA_WithdrawalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_WithdrawalEntity>>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContext,
    }
    @genType
    type handlerContextAsync = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContextAsync,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContextAsync,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContextAsync,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContextAsync,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContextAsync,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContextAsync,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContextAsync,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ApprovalEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ClaimRewardEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_DepositEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_NewRewardPoolEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_TransferEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_WithdrawalEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addZETA: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityLoaderContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityLoaderContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityLoaderContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityLoaderContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityLoaderContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityLoaderContext,
    }
  }
  module NewRewardPoolEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {@as("0") rewardPool: Ethers.ethAddress}

    @spice @genType
    type eventArgs = {rewardPool: Ethers.ethAddress}

    @genType.as("ZETAContract_NewRewardPool_EventLog")
    type log = eventLog<eventArgs>

    // Entity: EventsSummary
    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    type eventsSummaryEntityHandlerContextAsync = {
      get: id => promise<option<eventsSummaryEntity>>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Approval
    type zETA_ApprovalEntityHandlerContext = {
      get: id => option<zETA_ApprovalEntity>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    type zETA_ApprovalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ApprovalEntity>>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_ClaimReward
    type zETA_ClaimRewardEntityHandlerContext = {
      get: id => option<zETA_ClaimRewardEntity>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    type zETA_ClaimRewardEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ClaimRewardEntity>>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Deposit
    type zETA_DepositEntityHandlerContext = {
      get: id => option<zETA_DepositEntity>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    type zETA_DepositEntityHandlerContextAsync = {
      get: id => promise<option<zETA_DepositEntity>>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_NewRewardPool
    type zETA_NewRewardPoolEntityHandlerContext = {
      get: id => option<zETA_NewRewardPoolEntity>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    type zETA_NewRewardPoolEntityHandlerContextAsync = {
      get: id => promise<option<zETA_NewRewardPoolEntity>>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Transfer
    type zETA_TransferEntityHandlerContext = {
      get: id => option<zETA_TransferEntity>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    type zETA_TransferEntityHandlerContextAsync = {
      get: id => promise<option<zETA_TransferEntity>>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Withdrawal
    type zETA_WithdrawalEntityHandlerContext = {
      get: id => option<zETA_WithdrawalEntity>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    type zETA_WithdrawalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_WithdrawalEntity>>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContext,
    }
    @genType
    type handlerContextAsync = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContextAsync,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContextAsync,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContextAsync,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContextAsync,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContextAsync,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContextAsync,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContextAsync,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ApprovalEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ClaimRewardEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_DepositEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_NewRewardPoolEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_TransferEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_WithdrawalEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addZETA: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityLoaderContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityLoaderContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityLoaderContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityLoaderContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityLoaderContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityLoaderContext,
    }
  }
  module TransferEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") from: Ethers.ethAddress,
      @as("1") to: Ethers.ethAddress,
      @as("2") value: Ethers.BigInt.t,
    }

    @spice @genType
    type eventArgs = {
      from: Ethers.ethAddress,
      to: Ethers.ethAddress,
      value: Ethers.BigInt.t,
    }

    @genType.as("ZETAContract_Transfer_EventLog")
    type log = eventLog<eventArgs>

    // Entity: EventsSummary
    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    type eventsSummaryEntityHandlerContextAsync = {
      get: id => promise<option<eventsSummaryEntity>>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Approval
    type zETA_ApprovalEntityHandlerContext = {
      get: id => option<zETA_ApprovalEntity>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    type zETA_ApprovalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ApprovalEntity>>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_ClaimReward
    type zETA_ClaimRewardEntityHandlerContext = {
      get: id => option<zETA_ClaimRewardEntity>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    type zETA_ClaimRewardEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ClaimRewardEntity>>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Deposit
    type zETA_DepositEntityHandlerContext = {
      get: id => option<zETA_DepositEntity>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    type zETA_DepositEntityHandlerContextAsync = {
      get: id => promise<option<zETA_DepositEntity>>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_NewRewardPool
    type zETA_NewRewardPoolEntityHandlerContext = {
      get: id => option<zETA_NewRewardPoolEntity>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    type zETA_NewRewardPoolEntityHandlerContextAsync = {
      get: id => promise<option<zETA_NewRewardPoolEntity>>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Transfer
    type zETA_TransferEntityHandlerContext = {
      get: id => option<zETA_TransferEntity>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    type zETA_TransferEntityHandlerContextAsync = {
      get: id => promise<option<zETA_TransferEntity>>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Withdrawal
    type zETA_WithdrawalEntityHandlerContext = {
      get: id => option<zETA_WithdrawalEntity>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    type zETA_WithdrawalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_WithdrawalEntity>>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContext,
    }
    @genType
    type handlerContextAsync = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContextAsync,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContextAsync,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContextAsync,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContextAsync,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContextAsync,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContextAsync,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContextAsync,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ApprovalEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ClaimRewardEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_DepositEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_NewRewardPoolEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_TransferEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_WithdrawalEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addZETA: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityLoaderContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityLoaderContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityLoaderContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityLoaderContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityLoaderContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityLoaderContext,
    }
  }
  module WithdrawalEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") account: Ethers.ethAddress,
      @as("1") idx: Ethers.BigInt.t,
      @as("2") amount: Ethers.BigInt.t,
    }

    @spice @genType
    type eventArgs = {
      account: Ethers.ethAddress,
      idx: Ethers.BigInt.t,
      amount: Ethers.BigInt.t,
    }

    @genType.as("ZETAContract_Withdrawal_EventLog")
    type log = eventLog<eventArgs>

    // Entity: EventsSummary
    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    type eventsSummaryEntityHandlerContextAsync = {
      get: id => promise<option<eventsSummaryEntity>>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Approval
    type zETA_ApprovalEntityHandlerContext = {
      get: id => option<zETA_ApprovalEntity>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    type zETA_ApprovalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ApprovalEntity>>,
      set: zETA_ApprovalEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_ClaimReward
    type zETA_ClaimRewardEntityHandlerContext = {
      get: id => option<zETA_ClaimRewardEntity>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    type zETA_ClaimRewardEntityHandlerContextAsync = {
      get: id => promise<option<zETA_ClaimRewardEntity>>,
      set: zETA_ClaimRewardEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Deposit
    type zETA_DepositEntityHandlerContext = {
      get: id => option<zETA_DepositEntity>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    type zETA_DepositEntityHandlerContextAsync = {
      get: id => promise<option<zETA_DepositEntity>>,
      set: zETA_DepositEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_NewRewardPool
    type zETA_NewRewardPoolEntityHandlerContext = {
      get: id => option<zETA_NewRewardPoolEntity>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    type zETA_NewRewardPoolEntityHandlerContextAsync = {
      get: id => promise<option<zETA_NewRewardPoolEntity>>,
      set: zETA_NewRewardPoolEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Transfer
    type zETA_TransferEntityHandlerContext = {
      get: id => option<zETA_TransferEntity>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    type zETA_TransferEntityHandlerContextAsync = {
      get: id => promise<option<zETA_TransferEntity>>,
      set: zETA_TransferEntity => unit,
      delete: id => unit,
    }

    // Entity: ZETA_Withdrawal
    type zETA_WithdrawalEntityHandlerContext = {
      get: id => option<zETA_WithdrawalEntity>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    type zETA_WithdrawalEntityHandlerContextAsync = {
      get: id => promise<option<zETA_WithdrawalEntity>>,
      set: zETA_WithdrawalEntity => unit,
      delete: id => unit,
    }

    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContext,
    }
    @genType
    type handlerContextAsync = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContextAsync,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityHandlerContextAsync,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityHandlerContextAsync,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityHandlerContextAsync,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityHandlerContextAsync,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityHandlerContextAsync,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityHandlerContextAsync,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ApprovalEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_ClaimRewardEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_DepositEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_NewRewardPoolEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_TransferEntityLoaderContext = {load: id => unit}
    @genType
    type zETA_WithdrawalEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addZETA: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
      @as("ZETA_Approval") zETA_Approval: zETA_ApprovalEntityLoaderContext,
      @as("ZETA_ClaimReward") zETA_ClaimReward: zETA_ClaimRewardEntityLoaderContext,
      @as("ZETA_Deposit") zETA_Deposit: zETA_DepositEntityLoaderContext,
      @as("ZETA_NewRewardPool") zETA_NewRewardPool: zETA_NewRewardPoolEntityLoaderContext,
      @as("ZETA_Transfer") zETA_Transfer: zETA_TransferEntityLoaderContext,
      @as("ZETA_Withdrawal") zETA_Withdrawal: zETA_WithdrawalEntityLoaderContext,
    }
  }
}

@deriving(accessors)
type event =
  | ZETAContract_Approval(eventLog<ZETAContract.ApprovalEvent.eventArgs>)
  | ZETAContract_ClaimReward(eventLog<ZETAContract.ClaimRewardEvent.eventArgs>)
  | ZETAContract_Deposit(eventLog<ZETAContract.DepositEvent.eventArgs>)
  | ZETAContract_NewRewardPool(eventLog<ZETAContract.NewRewardPoolEvent.eventArgs>)
  | ZETAContract_Transfer(eventLog<ZETAContract.TransferEvent.eventArgs>)
  | ZETAContract_Withdrawal(eventLog<ZETAContract.WithdrawalEvent.eventArgs>)

@spice
type eventName =
  | @spice.as("ZETA_Approval") ZETA_Approval
  | @spice.as("ZETA_ClaimReward") ZETA_ClaimReward
  | @spice.as("ZETA_Deposit") ZETA_Deposit
  | @spice.as("ZETA_NewRewardPool") ZETA_NewRewardPool
  | @spice.as("ZETA_Transfer") ZETA_Transfer
  | @spice.as("ZETA_Withdrawal") ZETA_Withdrawal

let eventNameToString = (eventName: eventName) =>
  switch eventName {
  | ZETA_Approval => "Approval"
  | ZETA_ClaimReward => "ClaimReward"
  | ZETA_Deposit => "Deposit"
  | ZETA_NewRewardPool => "NewRewardPool"
  | ZETA_Transfer => "Transfer"
  | ZETA_Withdrawal => "Withdrawal"
  }

@genType
type chainId = int

type eventBatchQueueItem = {
  timestamp: int,
  chainId: int,
  blockNumber: int,
  logIndex: int,
  event: event,
}
