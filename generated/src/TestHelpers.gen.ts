/* TypeScript file generated from TestHelpers.res by genType. */
/* eslint-disable import/first */


// @ts-ignore: Implicit any on import
const TestHelpersBS = require('./TestHelpers.bs');

import type {BigInt_t as Ethers_BigInt_t} from '../src/bindings/Ethers.gen';

import type {ZETAContract_ApprovalEvent_eventArgs as Types_ZETAContract_ApprovalEvent_eventArgs} from './Types.gen';

import type {ZETAContract_ClaimRewardEvent_eventArgs as Types_ZETAContract_ClaimRewardEvent_eventArgs} from './Types.gen';

import type {ZETAContract_DepositEvent_eventArgs as Types_ZETAContract_DepositEvent_eventArgs} from './Types.gen';

import type {ZETAContract_NewRewardPoolEvent_eventArgs as Types_ZETAContract_NewRewardPoolEvent_eventArgs} from './Types.gen';

import type {ZETAContract_TransferEvent_eventArgs as Types_ZETAContract_TransferEvent_eventArgs} from './Types.gen';

import type {ZETAContract_WithdrawalEvent_eventArgs as Types_ZETAContract_WithdrawalEvent_eventArgs} from './Types.gen';

import type {ethAddress as Ethers_ethAddress} from '../src/bindings/Ethers.gen';

import type {eventLog as Types_eventLog} from './Types.gen';

import type {t as TestHelpers_MockDb_t} from './TestHelpers_MockDb.gen';

// tslint:disable-next-line:interface-over-type-literal
export type EventFunctions_eventProcessorArgs<eventArgs> = {
  readonly event: Types_eventLog<eventArgs>; 
  readonly mockDb: TestHelpers_MockDb_t; 
  readonly chainId?: number
};

// tslint:disable-next-line:interface-over-type-literal
export type EventFunctions_mockEventData = {
  readonly blockNumber?: number; 
  readonly blockTimestamp?: number; 
  readonly blockHash?: string; 
  readonly chainId?: number; 
  readonly srcAddress?: Ethers_ethAddress; 
  readonly transactionHash?: string; 
  readonly transactionIndex?: number; 
  readonly logIndex?: number
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETA_Approval_createMockArgs = {
  readonly owner?: Ethers_ethAddress; 
  readonly spender?: Ethers_ethAddress; 
  readonly value?: Ethers_BigInt_t; 
  readonly mockEventData?: EventFunctions_mockEventData
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETA_ClaimReward_createMockArgs = {
  readonly account?: Ethers_ethAddress; 
  readonly idx?: Ethers_BigInt_t; 
  readonly amount?: Ethers_BigInt_t; 
  readonly mockEventData?: EventFunctions_mockEventData
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETA_Deposit_createMockArgs = {
  readonly account?: Ethers_ethAddress; 
  readonly idx?: Ethers_BigInt_t; 
  readonly amount?: Ethers_BigInt_t; 
  readonly mockEventData?: EventFunctions_mockEventData
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETA_NewRewardPool_createMockArgs = { readonly rewardPool?: Ethers_ethAddress; readonly mockEventData?: EventFunctions_mockEventData };

// tslint:disable-next-line:interface-over-type-literal
export type ZETA_Transfer_createMockArgs = {
  readonly from?: Ethers_ethAddress; 
  readonly to?: Ethers_ethAddress; 
  readonly value?: Ethers_BigInt_t; 
  readonly mockEventData?: EventFunctions_mockEventData
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETA_Withdrawal_createMockArgs = {
  readonly account?: Ethers_ethAddress; 
  readonly idx?: Ethers_BigInt_t; 
  readonly amount?: Ethers_BigInt_t; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export const MockDb_createMockDb: () => TestHelpers_MockDb_t = TestHelpersBS.MockDb.createMockDb;

export const ZETA_Approval_processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_ApprovalEvent_eventArgs>) => TestHelpers_MockDb_t = TestHelpersBS.ZETA.Approval.processEvent;

export const ZETA_Approval_processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_ApprovalEvent_eventArgs>) => Promise<TestHelpers_MockDb_t> = TestHelpersBS.ZETA.Approval.processEventAsync;

export const ZETA_Approval_createMockEvent: (args:ZETA_Approval_createMockArgs) => Types_eventLog<Types_ZETAContract_ApprovalEvent_eventArgs> = TestHelpersBS.ZETA.Approval.createMockEvent;

export const ZETA_ClaimReward_processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_ClaimRewardEvent_eventArgs>) => TestHelpers_MockDb_t = TestHelpersBS.ZETA.ClaimReward.processEvent;

export const ZETA_ClaimReward_processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_ClaimRewardEvent_eventArgs>) => Promise<TestHelpers_MockDb_t> = TestHelpersBS.ZETA.ClaimReward.processEventAsync;

export const ZETA_ClaimReward_createMockEvent: (args:ZETA_ClaimReward_createMockArgs) => Types_eventLog<Types_ZETAContract_ClaimRewardEvent_eventArgs> = TestHelpersBS.ZETA.ClaimReward.createMockEvent;

export const ZETA_Deposit_processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_DepositEvent_eventArgs>) => TestHelpers_MockDb_t = TestHelpersBS.ZETA.Deposit.processEvent;

export const ZETA_Deposit_processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_DepositEvent_eventArgs>) => Promise<TestHelpers_MockDb_t> = TestHelpersBS.ZETA.Deposit.processEventAsync;

export const ZETA_Deposit_createMockEvent: (args:ZETA_Deposit_createMockArgs) => Types_eventLog<Types_ZETAContract_DepositEvent_eventArgs> = TestHelpersBS.ZETA.Deposit.createMockEvent;

export const ZETA_NewRewardPool_processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_NewRewardPoolEvent_eventArgs>) => TestHelpers_MockDb_t = TestHelpersBS.ZETA.NewRewardPool.processEvent;

export const ZETA_NewRewardPool_processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_NewRewardPoolEvent_eventArgs>) => Promise<TestHelpers_MockDb_t> = TestHelpersBS.ZETA.NewRewardPool.processEventAsync;

export const ZETA_NewRewardPool_createMockEvent: (args:ZETA_NewRewardPool_createMockArgs) => Types_eventLog<Types_ZETAContract_NewRewardPoolEvent_eventArgs> = TestHelpersBS.ZETA.NewRewardPool.createMockEvent;

export const ZETA_Transfer_processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_TransferEvent_eventArgs>) => TestHelpers_MockDb_t = TestHelpersBS.ZETA.Transfer.processEvent;

export const ZETA_Transfer_processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_TransferEvent_eventArgs>) => Promise<TestHelpers_MockDb_t> = TestHelpersBS.ZETA.Transfer.processEventAsync;

export const ZETA_Transfer_createMockEvent: (args:ZETA_Transfer_createMockArgs) => Types_eventLog<Types_ZETAContract_TransferEvent_eventArgs> = TestHelpersBS.ZETA.Transfer.createMockEvent;

export const ZETA_Withdrawal_processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_WithdrawalEvent_eventArgs>) => TestHelpers_MockDb_t = TestHelpersBS.ZETA.Withdrawal.processEvent;

export const ZETA_Withdrawal_processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_WithdrawalEvent_eventArgs>) => Promise<TestHelpers_MockDb_t> = TestHelpersBS.ZETA.Withdrawal.processEventAsync;

export const ZETA_Withdrawal_createMockEvent: (args:ZETA_Withdrawal_createMockArgs) => Types_eventLog<Types_ZETAContract_WithdrawalEvent_eventArgs> = TestHelpersBS.ZETA.Withdrawal.createMockEvent;

export const ZETA: {
  Deposit: {
    processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_DepositEvent_eventArgs>) => TestHelpers_MockDb_t; 
    processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_DepositEvent_eventArgs>) => Promise<TestHelpers_MockDb_t>; 
    createMockEvent: (args:ZETA_Deposit_createMockArgs) => Types_eventLog<Types_ZETAContract_DepositEvent_eventArgs>
  }; 
  Withdrawal: {
    processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_WithdrawalEvent_eventArgs>) => TestHelpers_MockDb_t; 
    processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_WithdrawalEvent_eventArgs>) => Promise<TestHelpers_MockDb_t>; 
    createMockEvent: (args:ZETA_Withdrawal_createMockArgs) => Types_eventLog<Types_ZETAContract_WithdrawalEvent_eventArgs>
  }; 
  ClaimReward: {
    processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_ClaimRewardEvent_eventArgs>) => TestHelpers_MockDb_t; 
    processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_ClaimRewardEvent_eventArgs>) => Promise<TestHelpers_MockDb_t>; 
    createMockEvent: (args:ZETA_ClaimReward_createMockArgs) => Types_eventLog<Types_ZETAContract_ClaimRewardEvent_eventArgs>
  }; 
  Transfer: {
    processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_TransferEvent_eventArgs>) => TestHelpers_MockDb_t; 
    processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_TransferEvent_eventArgs>) => Promise<TestHelpers_MockDb_t>; 
    createMockEvent: (args:ZETA_Transfer_createMockArgs) => Types_eventLog<Types_ZETAContract_TransferEvent_eventArgs>
  }; 
  NewRewardPool: {
    processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_NewRewardPoolEvent_eventArgs>) => TestHelpers_MockDb_t; 
    processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_NewRewardPoolEvent_eventArgs>) => Promise<TestHelpers_MockDb_t>; 
    createMockEvent: (args:ZETA_NewRewardPool_createMockArgs) => Types_eventLog<Types_ZETAContract_NewRewardPoolEvent_eventArgs>
  }; 
  Approval: {
    processEvent: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_ApprovalEvent_eventArgs>) => TestHelpers_MockDb_t; 
    processEventAsync: (_1:EventFunctions_eventProcessorArgs<Types_ZETAContract_ApprovalEvent_eventArgs>) => Promise<TestHelpers_MockDb_t>; 
    createMockEvent: (args:ZETA_Approval_createMockArgs) => Types_eventLog<Types_ZETAContract_ApprovalEvent_eventArgs>
  }
} = TestHelpersBS.ZETA

export const MockDb: { createMockDb: () => TestHelpers_MockDb_t } = TestHelpersBS.MockDb
