exception UndefinedEvent(string)

let eventStringToEvent = (eventName: string, contractName: string): Types.eventName => {
  switch (eventName, contractName) {
  | ("Approval", "ZETA") => ZETA_Approval
  | ("ClaimReward", "ZETA") => ZETA_ClaimReward
  | ("Deposit", "ZETA") => ZETA_Deposit
  | ("NewRewardPool", "ZETA") => ZETA_NewRewardPool
  | ("Transfer", "ZETA") => ZETA_Transfer
  | ("Withdrawal", "ZETA") => ZETA_Withdrawal
  | _ => UndefinedEvent(eventName)->raise
  }
}

module ZETA = {
  let convertApprovalViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.ZETAContract.ApprovalEvent.eventArgs,
  > = Obj.magic

  let convertApprovalLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.ZETAContract.ApprovalEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<Types.ZETAContract.ApprovalEvent.ethersEventArgs> =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        owner: args.owner,
        spender: args.spender,
        value: args.value,
      },
    }
  }

  let convertApprovalLog = (
    logDescription: Ethers.logDescription<Types.ZETAContract.ApprovalEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.ApprovalEvent.eventArgs = {
      owner: logDescription.args.owner,
      spender: logDescription.args.spender,
      value: logDescription.args.value,
    }

    let approvalLog: Types.eventLog<Types.ZETAContract.ApprovalEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_Approval(approvalLog)
  }
  let convertApprovalLogViem = (
    decodedEvent: Viem.decodedEvent<Types.ZETAContract.ApprovalEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.ApprovalEvent.eventArgs = {
      owner: decodedEvent.args.owner,
      spender: decodedEvent.args.spender,
      value: decodedEvent.args.value,
    }

    let approvalLog: Types.eventLog<Types.ZETAContract.ApprovalEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_Approval(approvalLog)
  }

  let convertClaimRewardViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.ZETAContract.ClaimRewardEvent.eventArgs,
  > = Obj.magic

  let convertClaimRewardLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.ZETAContract.ClaimRewardEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<Types.ZETAContract.ClaimRewardEvent.ethersEventArgs> =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        account: args.account,
        idx: args.idx,
        amount: args.amount,
      },
    }
  }

  let convertClaimRewardLog = (
    logDescription: Ethers.logDescription<Types.ZETAContract.ClaimRewardEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.ClaimRewardEvent.eventArgs = {
      account: logDescription.args.account,
      idx: logDescription.args.idx,
      amount: logDescription.args.amount,
    }

    let claimRewardLog: Types.eventLog<Types.ZETAContract.ClaimRewardEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_ClaimReward(claimRewardLog)
  }
  let convertClaimRewardLogViem = (
    decodedEvent: Viem.decodedEvent<Types.ZETAContract.ClaimRewardEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.ClaimRewardEvent.eventArgs = {
      account: decodedEvent.args.account,
      idx: decodedEvent.args.idx,
      amount: decodedEvent.args.amount,
    }

    let claimRewardLog: Types.eventLog<Types.ZETAContract.ClaimRewardEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_ClaimReward(claimRewardLog)
  }

  let convertDepositViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.ZETAContract.DepositEvent.eventArgs,
  > = Obj.magic

  let convertDepositLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.ZETAContract.DepositEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<Types.ZETAContract.DepositEvent.ethersEventArgs> =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        account: args.account,
        idx: args.idx,
        amount: args.amount,
      },
    }
  }

  let convertDepositLog = (
    logDescription: Ethers.logDescription<Types.ZETAContract.DepositEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.DepositEvent.eventArgs = {
      account: logDescription.args.account,
      idx: logDescription.args.idx,
      amount: logDescription.args.amount,
    }

    let depositLog: Types.eventLog<Types.ZETAContract.DepositEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_Deposit(depositLog)
  }
  let convertDepositLogViem = (
    decodedEvent: Viem.decodedEvent<Types.ZETAContract.DepositEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.DepositEvent.eventArgs = {
      account: decodedEvent.args.account,
      idx: decodedEvent.args.idx,
      amount: decodedEvent.args.amount,
    }

    let depositLog: Types.eventLog<Types.ZETAContract.DepositEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_Deposit(depositLog)
  }

  let convertNewRewardPoolViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.ZETAContract.NewRewardPoolEvent.eventArgs,
  > = Obj.magic

  let convertNewRewardPoolLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.ZETAContract.NewRewardPoolEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<Types.ZETAContract.NewRewardPoolEvent.ethersEventArgs> =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        rewardPool: args.rewardPool,
      },
    }
  }

  let convertNewRewardPoolLog = (
    logDescription: Ethers.logDescription<Types.ZETAContract.NewRewardPoolEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.NewRewardPoolEvent.eventArgs = {
      rewardPool: logDescription.args.rewardPool,
    }

    let newRewardPoolLog: Types.eventLog<Types.ZETAContract.NewRewardPoolEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_NewRewardPool(newRewardPoolLog)
  }
  let convertNewRewardPoolLogViem = (
    decodedEvent: Viem.decodedEvent<Types.ZETAContract.NewRewardPoolEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.NewRewardPoolEvent.eventArgs = {
      rewardPool: decodedEvent.args.rewardPool,
    }

    let newRewardPoolLog: Types.eventLog<Types.ZETAContract.NewRewardPoolEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_NewRewardPool(newRewardPoolLog)
  }

  let convertTransferViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.ZETAContract.TransferEvent.eventArgs,
  > = Obj.magic

  let convertTransferLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.ZETAContract.TransferEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<Types.ZETAContract.TransferEvent.ethersEventArgs> =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        from: args.from,
        to: args.to,
        value: args.value,
      },
    }
  }

  let convertTransferLog = (
    logDescription: Ethers.logDescription<Types.ZETAContract.TransferEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.TransferEvent.eventArgs = {
      from: logDescription.args.from,
      to: logDescription.args.to,
      value: logDescription.args.value,
    }

    let transferLog: Types.eventLog<Types.ZETAContract.TransferEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_Transfer(transferLog)
  }
  let convertTransferLogViem = (
    decodedEvent: Viem.decodedEvent<Types.ZETAContract.TransferEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.TransferEvent.eventArgs = {
      from: decodedEvent.args.from,
      to: decodedEvent.args.to,
      value: decodedEvent.args.value,
    }

    let transferLog: Types.eventLog<Types.ZETAContract.TransferEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_Transfer(transferLog)
  }

  let convertWithdrawalViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.ZETAContract.WithdrawalEvent.eventArgs,
  > = Obj.magic

  let convertWithdrawalLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.ZETAContract.WithdrawalEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<Types.ZETAContract.WithdrawalEvent.ethersEventArgs> =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        account: args.account,
        idx: args.idx,
        amount: args.amount,
      },
    }
  }

  let convertWithdrawalLog = (
    logDescription: Ethers.logDescription<Types.ZETAContract.WithdrawalEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.WithdrawalEvent.eventArgs = {
      account: logDescription.args.account,
      idx: logDescription.args.idx,
      amount: logDescription.args.amount,
    }

    let withdrawalLog: Types.eventLog<Types.ZETAContract.WithdrawalEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_Withdrawal(withdrawalLog)
  }
  let convertWithdrawalLogViem = (
    decodedEvent: Viem.decodedEvent<Types.ZETAContract.WithdrawalEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
    ~chainId: int,
  ) => {
    let params: Types.ZETAContract.WithdrawalEvent.eventArgs = {
      account: decodedEvent.args.account,
      idx: decodedEvent.args.idx,
      amount: decodedEvent.args.amount,
    }

    let withdrawalLog: Types.eventLog<Types.ZETAContract.WithdrawalEvent.eventArgs> = {
      params,
      chainId,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.ZETAContract_Withdrawal(withdrawalLog)
  }
}

type parseEventError =
  ParseError(Ethers.Interface.parseLogError) | UnregisteredContract(Ethers.ethAddress)

exception ParseEventErrorExn(parseEventError)

let parseEventEthers = (~log, ~blockTimestamp, ~contractInterfaceManager, ~chainId): Belt.Result.t<
  Types.event,
  _,
> => {
  let logDescriptionResult = contractInterfaceManager->ContractInterfaceManager.parseLogEthers(~log)
  switch logDescriptionResult {
  | Error(e) =>
    switch e {
    | ParseError(parseError) => ParseError(parseError)
    | UndefinedInterface(contractAddress) => UnregisteredContract(contractAddress)
    }->Error

  | Ok(logDescription) =>
    switch contractInterfaceManager->ContractInterfaceManager.getContractNameFromAddress(
      ~contractAddress=log.address,
    ) {
    | None => Error(UnregisteredContract(log.address))
    | Some(contractName) =>
      let event = switch eventStringToEvent(logDescription.name, contractName) {
      | ZETA_Approval =>
        logDescription
        ->ZETA.convertApprovalLogDescription
        ->ZETA.convertApprovalLog(~log, ~blockTimestamp, ~chainId)
      | ZETA_ClaimReward =>
        logDescription
        ->ZETA.convertClaimRewardLogDescription
        ->ZETA.convertClaimRewardLog(~log, ~blockTimestamp, ~chainId)
      | ZETA_Deposit =>
        logDescription
        ->ZETA.convertDepositLogDescription
        ->ZETA.convertDepositLog(~log, ~blockTimestamp, ~chainId)
      | ZETA_NewRewardPool =>
        logDescription
        ->ZETA.convertNewRewardPoolLogDescription
        ->ZETA.convertNewRewardPoolLog(~log, ~blockTimestamp, ~chainId)
      | ZETA_Transfer =>
        logDescription
        ->ZETA.convertTransferLogDescription
        ->ZETA.convertTransferLog(~log, ~blockTimestamp, ~chainId)
      | ZETA_Withdrawal =>
        logDescription
        ->ZETA.convertWithdrawalLogDescription
        ->ZETA.convertWithdrawalLog(~log, ~blockTimestamp, ~chainId)
      }

      Ok(event)
    }
  }
}

let parseEvent = (~log, ~blockTimestamp, ~contractInterfaceManager, ~chainId): Belt.Result.t<
  Types.event,
  _,
> => {
  let decodedEventResult = contractInterfaceManager->ContractInterfaceManager.parseLogViem(~log)
  switch decodedEventResult {
  | Error(e) =>
    switch e {
    | ParseError(parseError) => ParseError(parseError)
    | UndefinedInterface(contractAddress) => UnregisteredContract(contractAddress)
    }->Error

  | Ok(decodedEvent) =>
    switch contractInterfaceManager->ContractInterfaceManager.getContractNameFromAddress(
      ~contractAddress=log.address,
    ) {
    | None => Error(UnregisteredContract(log.address))
    | Some(contractName) =>
      let event = switch eventStringToEvent(decodedEvent.eventName, contractName) {
      | ZETA_Approval =>
        decodedEvent
        ->ZETA.convertApprovalViemDecodedEvent
        ->ZETA.convertApprovalLogViem(~log, ~blockTimestamp, ~chainId)
      | ZETA_ClaimReward =>
        decodedEvent
        ->ZETA.convertClaimRewardViemDecodedEvent
        ->ZETA.convertClaimRewardLogViem(~log, ~blockTimestamp, ~chainId)
      | ZETA_Deposit =>
        decodedEvent
        ->ZETA.convertDepositViemDecodedEvent
        ->ZETA.convertDepositLogViem(~log, ~blockTimestamp, ~chainId)
      | ZETA_NewRewardPool =>
        decodedEvent
        ->ZETA.convertNewRewardPoolViemDecodedEvent
        ->ZETA.convertNewRewardPoolLogViem(~log, ~blockTimestamp, ~chainId)
      | ZETA_Transfer =>
        decodedEvent
        ->ZETA.convertTransferViemDecodedEvent
        ->ZETA.convertTransferLogViem(~log, ~blockTimestamp, ~chainId)
      | ZETA_Withdrawal =>
        decodedEvent
        ->ZETA.convertWithdrawalViemDecodedEvent
        ->ZETA.convertWithdrawalLogViem(~log, ~blockTimestamp, ~chainId)
      }

      Ok(event)
    }
  }
}

let decodeRawEventWith = (
  rawEvent: Types.rawEventsEntity,
  ~decoder: Spice.decoder<'a>,
  ~variantAccessor: Types.eventLog<'a> => Types.event,
  ~chainId: int,
): Spice.result<Types.eventBatchQueueItem> => {
  switch rawEvent.params->Js.Json.parseExn {
  | exception exn =>
    let message =
      exn
      ->Js.Exn.asJsExn
      ->Belt.Option.flatMap(jsexn => jsexn->Js.Exn.message)
      ->Belt.Option.getWithDefault("No message on exn")

    Spice.error(`Failed at JSON.parse. Error: ${message}`, rawEvent.params->Obj.magic)
  | v => Ok(v)
  }
  ->Belt.Result.flatMap(json => {
    json->decoder
  })
  ->Belt.Result.map(params => {
    let event = {
      chainId,
      blockNumber: rawEvent.blockNumber,
      blockTimestamp: rawEvent.blockTimestamp,
      blockHash: rawEvent.blockHash,
      srcAddress: rawEvent.srcAddress,
      transactionHash: rawEvent.transactionHash,
      transactionIndex: rawEvent.transactionIndex,
      logIndex: rawEvent.logIndex,
      params,
    }->variantAccessor

    let queueItem: Types.eventBatchQueueItem = {
      timestamp: rawEvent.blockTimestamp,
      chainId: rawEvent.chainId,
      blockNumber: rawEvent.blockNumber,
      logIndex: rawEvent.logIndex,
      event,
    }

    queueItem
  })
}

let parseRawEvent = (rawEvent: Types.rawEventsEntity, ~chainId: int): Spice.result<
  Types.eventBatchQueueItem,
> => {
  rawEvent.eventType
  ->Types.eventName_decode
  ->Belt.Result.flatMap(eventName => {
    switch eventName {
    | ZETA_Approval =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.ZETAContract.ApprovalEvent.eventArgs_decode,
        ~variantAccessor=Types.zETAContract_Approval,
        ~chainId,
      )
    | ZETA_ClaimReward =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.ZETAContract.ClaimRewardEvent.eventArgs_decode,
        ~variantAccessor=Types.zETAContract_ClaimReward,
        ~chainId,
      )
    | ZETA_Deposit =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.ZETAContract.DepositEvent.eventArgs_decode,
        ~variantAccessor=Types.zETAContract_Deposit,
        ~chainId,
      )
    | ZETA_NewRewardPool =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.ZETAContract.NewRewardPoolEvent.eventArgs_decode,
        ~variantAccessor=Types.zETAContract_NewRewardPool,
        ~chainId,
      )
    | ZETA_Transfer =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.ZETAContract.TransferEvent.eventArgs_decode,
        ~variantAccessor=Types.zETAContract_Transfer,
        ~chainId,
      )
    | ZETA_Withdrawal =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.ZETAContract.WithdrawalEvent.eventArgs_decode,
        ~variantAccessor=Types.zETAContract_Withdrawal,
        ~chainId,
      )
    }
  })
}
