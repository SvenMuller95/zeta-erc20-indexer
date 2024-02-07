/*
 *Please refer to https://docs.envio.dev for a thorough guide on all Envio indexer features*
 */
import {
    ZETAContract_Approval_loader,
    ZETAContract_Approval_handler,
    ZETAContract_ClaimReward_loader,
    ZETAContract_ClaimReward_handler,
    ZETAContract_Deposit_loader,
    ZETAContract_Deposit_handler,
    ZETAContract_NewRewardPool_loader,
    ZETAContract_NewRewardPool_handler,
    ZETAContract_Transfer_loader,
    ZETAContract_Transfer_handler,
    ZETAContract_Withdrawal_loader,
    ZETAContract_Withdrawal_handler,
} from "../generated/src/Handlers.gen";

import {
    ZETA_ApprovalEntity,
    ZETA_ClaimRewardEntity,
    ZETA_DepositEntity,
    ZETA_NewRewardPoolEntity,
    ZETA_TransferEntity,
    ZETA_WithdrawalEntity,
EventsSummaryEntity
} from "./src/Types.gen";

const GLOBAL_EVENTS_SUMMARY_KEY = "GlobalEventsSummary";

const INITIAL_EVENTS_SUMMARY: EventsSummaryEntity = {
  id: GLOBAL_EVENTS_SUMMARY_KEY,
    zETA_ApprovalCount: BigInt(0),
    zETA_ClaimRewardCount: BigInt(0),
    zETA_DepositCount: BigInt(0),
    zETA_NewRewardPoolCount: BigInt(0),
    zETA_TransferCount: BigInt(0),
    zETA_WithdrawalCount: BigInt(0),
};

    ZETAContract_Approval_loader(({ event, context }) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    ZETAContract_Approval_handler(({ event, context }) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity: EventsSummaryEntity =
    summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    zETA_ApprovalCount: currentSummaryEntity.zETA_ApprovalCount + BigInt(1),
  };

  const zETA_ApprovalEntity: ZETA_ApprovalEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      owner: event.params.owner      ,
      spender: event.params.spender      ,
      value: event.params.value      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.ZETA_Approval.set(zETA_ApprovalEntity);
});
    ZETAContract_ClaimReward_loader(({ event, context }) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    ZETAContract_ClaimReward_handler(({ event, context }) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity: EventsSummaryEntity =
    summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    zETA_ClaimRewardCount: currentSummaryEntity.zETA_ClaimRewardCount + BigInt(1),
  };

  const zETA_ClaimRewardEntity: ZETA_ClaimRewardEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      account: event.params.account      ,
      idx: event.params.idx      ,
      amount: event.params.amount      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.ZETA_ClaimReward.set(zETA_ClaimRewardEntity);
});
    ZETAContract_Deposit_loader(({ event, context }) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    ZETAContract_Deposit_handler(({ event, context }) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity: EventsSummaryEntity =
    summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    zETA_DepositCount: currentSummaryEntity.zETA_DepositCount + BigInt(1),
  };

  const zETA_DepositEntity: ZETA_DepositEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      account: event.params.account      ,
      idx: event.params.idx      ,
      amount: event.params.amount      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.ZETA_Deposit.set(zETA_DepositEntity);
});
    ZETAContract_NewRewardPool_loader(({ event, context }) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    ZETAContract_NewRewardPool_handler(({ event, context }) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity: EventsSummaryEntity =
    summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    zETA_NewRewardPoolCount: currentSummaryEntity.zETA_NewRewardPoolCount + BigInt(1),
  };

  const zETA_NewRewardPoolEntity: ZETA_NewRewardPoolEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      rewardPool: event.params.rewardPool      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.ZETA_NewRewardPool.set(zETA_NewRewardPoolEntity);
});
    ZETAContract_Transfer_loader(({ event, context }) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    ZETAContract_Transfer_handler(({ event, context }) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity: EventsSummaryEntity =
    summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    zETA_TransferCount: currentSummaryEntity.zETA_TransferCount + BigInt(1),
  };

  const zETA_TransferEntity: ZETA_TransferEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      from: event.params.from      ,
      to: event.params.to      ,
      value: event.params.value      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.ZETA_Transfer.set(zETA_TransferEntity);
});
    ZETAContract_Withdrawal_loader(({ event, context }) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    ZETAContract_Withdrawal_handler(({ event, context }) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity: EventsSummaryEntity =
    summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    zETA_WithdrawalCount: currentSummaryEntity.zETA_WithdrawalCount + BigInt(1),
  };

  const zETA_WithdrawalEntity: ZETA_WithdrawalEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      account: event.params.account      ,
      idx: event.params.idx      ,
      amount: event.params.amount      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.ZETA_Withdrawal.set(zETA_WithdrawalEntity);
});
