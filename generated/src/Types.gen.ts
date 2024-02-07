/* TypeScript file generated from Types.res by genType. */
/* eslint-disable import/first */


import type {BigInt_t as Ethers_BigInt_t} from '../src/bindings/Ethers.gen';

import type {Json_t as Js_Json_t} from '../src/Js.shim';

import type {Nullable as $$nullable} from './bindings/OpaqueTypes';

import type {ethAddress as Ethers_ethAddress} from '../src/bindings/Ethers.gen';

import type {userLogger as Logs_userLogger} from './Logs.gen';

// tslint:disable-next-line:interface-over-type-literal
export type id = string;
export type Id = id;

// tslint:disable-next-line:interface-over-type-literal
export type nullable<a> = $$nullable<a>;

// tslint:disable-next-line:interface-over-type-literal
export type eventsSummaryLoaderConfig = boolean;

// tslint:disable-next-line:interface-over-type-literal
export type entityRead = 
    { tag: "EventsSummaryRead"; value: id }
  | { tag: "ZETA_ApprovalRead"; value: id }
  | { tag: "ZETA_ClaimRewardRead"; value: id }
  | { tag: "ZETA_DepositRead"; value: id }
  | { tag: "ZETA_NewRewardPoolRead"; value: id }
  | { tag: "ZETA_TransferRead"; value: id }
  | { tag: "ZETA_WithdrawalRead"; value: id };

// tslint:disable-next-line:interface-over-type-literal
export type rawEventsEntity = {
  readonly chain_id: number; 
  readonly event_id: string; 
  readonly block_number: number; 
  readonly log_index: number; 
  readonly transaction_index: number; 
  readonly transaction_hash: string; 
  readonly src_address: Ethers_ethAddress; 
  readonly block_hash: string; 
  readonly block_timestamp: number; 
  readonly event_type: Js_Json_t; 
  readonly params: string
};

// tslint:disable-next-line:interface-over-type-literal
export type dynamicContractRegistryEntity = {
  readonly chain_id: number; 
  readonly event_id: Ethers_BigInt_t; 
  readonly contract_address: Ethers_ethAddress; 
  readonly contract_type: string
};

// tslint:disable-next-line:interface-over-type-literal
export type eventsSummaryEntity = {
  readonly id: id; 
  readonly zETA_ApprovalCount: Ethers_BigInt_t; 
  readonly zETA_ClaimRewardCount: Ethers_BigInt_t; 
  readonly zETA_DepositCount: Ethers_BigInt_t; 
  readonly zETA_NewRewardPoolCount: Ethers_BigInt_t; 
  readonly zETA_TransferCount: Ethers_BigInt_t; 
  readonly zETA_WithdrawalCount: Ethers_BigInt_t
};
export type EventsSummaryEntity = eventsSummaryEntity;

// tslint:disable-next-line:interface-over-type-literal
export type zETA_ApprovalEntity = {
  readonly id: id; 
  readonly owner: string; 
  readonly spender: string; 
  readonly value: Ethers_BigInt_t; 
  readonly eventsSummary: string
};
export type ZETA_ApprovalEntity = zETA_ApprovalEntity;

// tslint:disable-next-line:interface-over-type-literal
export type zETA_ClaimRewardEntity = {
  readonly id: id; 
  readonly account: string; 
  readonly idx: Ethers_BigInt_t; 
  readonly amount: Ethers_BigInt_t; 
  readonly eventsSummary: string
};
export type ZETA_ClaimRewardEntity = zETA_ClaimRewardEntity;

// tslint:disable-next-line:interface-over-type-literal
export type zETA_DepositEntity = {
  readonly id: id; 
  readonly account: string; 
  readonly idx: Ethers_BigInt_t; 
  readonly amount: Ethers_BigInt_t; 
  readonly eventsSummary: string
};
export type ZETA_DepositEntity = zETA_DepositEntity;

// tslint:disable-next-line:interface-over-type-literal
export type zETA_NewRewardPoolEntity = {
  readonly id: id; 
  readonly rewardPool: string; 
  readonly eventsSummary: string
};
export type ZETA_NewRewardPoolEntity = zETA_NewRewardPoolEntity;

// tslint:disable-next-line:interface-over-type-literal
export type zETA_TransferEntity = {
  readonly id: id; 
  readonly from: string; 
  readonly to: string; 
  readonly value: Ethers_BigInt_t; 
  readonly eventsSummary: string
};
export type ZETA_TransferEntity = zETA_TransferEntity;

// tslint:disable-next-line:interface-over-type-literal
export type zETA_WithdrawalEntity = {
  readonly id: id; 
  readonly account: string; 
  readonly idx: Ethers_BigInt_t; 
  readonly amount: Ethers_BigInt_t; 
  readonly eventsSummary: string
};
export type ZETA_WithdrawalEntity = zETA_WithdrawalEntity;

// tslint:disable-next-line:interface-over-type-literal
export type eventLog<a> = {
  readonly params: a; 
  readonly chainId: number; 
  readonly blockNumber: number; 
  readonly blockTimestamp: number; 
  readonly blockHash: string; 
  readonly srcAddress: Ethers_ethAddress; 
  readonly transactionHash: string; 
  readonly transactionIndex: number; 
  readonly logIndex: number
};
export type EventLog<a> = eventLog<a>;

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_eventArgs = {
  readonly owner: Ethers_ethAddress; 
  readonly spender: Ethers_ethAddress; 
  readonly value: Ethers_BigInt_t
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_log = eventLog<ZETAContract_ApprovalEvent_eventArgs>;
export type ZETAContract_Approval_EventLog = ZETAContract_ApprovalEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_eventsSummaryEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | eventsSummaryEntity)>; 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_ApprovalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ApprovalEntity); 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_ApprovalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ApprovalEntity)>; 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_ClaimRewardEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ClaimRewardEntity); 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_ClaimRewardEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ClaimRewardEntity)>; 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_DepositEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_DepositEntity); 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_DepositEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_DepositEntity)>; 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_NewRewardPoolEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_NewRewardPoolEntity); 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_NewRewardPoolEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_NewRewardPoolEntity)>; 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_TransferEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_TransferEntity); 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_TransferEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_TransferEntity)>; 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_WithdrawalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_WithdrawalEntity); 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_WithdrawalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_WithdrawalEntity)>; 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_ApprovalEvent_eventsSummaryEntityHandlerContext; 
  readonly ZETA_Approval: ZETAContract_ApprovalEvent_zETA_ApprovalEntityHandlerContext; 
  readonly ZETA_ClaimReward: ZETAContract_ApprovalEvent_zETA_ClaimRewardEntityHandlerContext; 
  readonly ZETA_Deposit: ZETAContract_ApprovalEvent_zETA_DepositEntityHandlerContext; 
  readonly ZETA_NewRewardPool: ZETAContract_ApprovalEvent_zETA_NewRewardPoolEntityHandlerContext; 
  readonly ZETA_Transfer: ZETAContract_ApprovalEvent_zETA_TransferEntityHandlerContext; 
  readonly ZETA_Withdrawal: ZETAContract_ApprovalEvent_zETA_WithdrawalEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_handlerContextAsync = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_ApprovalEvent_eventsSummaryEntityHandlerContextAsync; 
  readonly ZETA_Approval: ZETAContract_ApprovalEvent_zETA_ApprovalEntityHandlerContextAsync; 
  readonly ZETA_ClaimReward: ZETAContract_ApprovalEvent_zETA_ClaimRewardEntityHandlerContextAsync; 
  readonly ZETA_Deposit: ZETAContract_ApprovalEvent_zETA_DepositEntityHandlerContextAsync; 
  readonly ZETA_NewRewardPool: ZETAContract_ApprovalEvent_zETA_NewRewardPoolEntityHandlerContextAsync; 
  readonly ZETA_Transfer: ZETAContract_ApprovalEvent_zETA_TransferEntityHandlerContextAsync; 
  readonly ZETA_Withdrawal: ZETAContract_ApprovalEvent_zETA_WithdrawalEntityHandlerContextAsync
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_ApprovalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_ClaimRewardEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_DepositEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_NewRewardPoolEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_TransferEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_zETA_WithdrawalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_contractRegistrations = { readonly addZETA: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ApprovalEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: ZETAContract_ApprovalEvent_contractRegistrations; 
  readonly EventsSummary: ZETAContract_ApprovalEvent_eventsSummaryEntityLoaderContext; 
  readonly ZETA_Approval: ZETAContract_ApprovalEvent_zETA_ApprovalEntityLoaderContext; 
  readonly ZETA_ClaimReward: ZETAContract_ApprovalEvent_zETA_ClaimRewardEntityLoaderContext; 
  readonly ZETA_Deposit: ZETAContract_ApprovalEvent_zETA_DepositEntityLoaderContext; 
  readonly ZETA_NewRewardPool: ZETAContract_ApprovalEvent_zETA_NewRewardPoolEntityLoaderContext; 
  readonly ZETA_Transfer: ZETAContract_ApprovalEvent_zETA_TransferEntityLoaderContext; 
  readonly ZETA_Withdrawal: ZETAContract_ApprovalEvent_zETA_WithdrawalEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_eventArgs = {
  readonly account: Ethers_ethAddress; 
  readonly idx: Ethers_BigInt_t; 
  readonly amount: Ethers_BigInt_t
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_log = eventLog<ZETAContract_ClaimRewardEvent_eventArgs>;
export type ZETAContract_ClaimReward_EventLog = ZETAContract_ClaimRewardEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_eventsSummaryEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | eventsSummaryEntity)>; 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_ApprovalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ApprovalEntity); 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_ApprovalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ApprovalEntity)>; 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_ClaimRewardEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ClaimRewardEntity); 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_ClaimRewardEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ClaimRewardEntity)>; 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_DepositEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_DepositEntity); 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_DepositEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_DepositEntity)>; 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_NewRewardPoolEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_NewRewardPoolEntity); 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_NewRewardPoolEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_NewRewardPoolEntity)>; 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_TransferEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_TransferEntity); 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_TransferEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_TransferEntity)>; 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_WithdrawalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_WithdrawalEntity); 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_WithdrawalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_WithdrawalEntity)>; 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_ClaimRewardEvent_eventsSummaryEntityHandlerContext; 
  readonly ZETA_Approval: ZETAContract_ClaimRewardEvent_zETA_ApprovalEntityHandlerContext; 
  readonly ZETA_ClaimReward: ZETAContract_ClaimRewardEvent_zETA_ClaimRewardEntityHandlerContext; 
  readonly ZETA_Deposit: ZETAContract_ClaimRewardEvent_zETA_DepositEntityHandlerContext; 
  readonly ZETA_NewRewardPool: ZETAContract_ClaimRewardEvent_zETA_NewRewardPoolEntityHandlerContext; 
  readonly ZETA_Transfer: ZETAContract_ClaimRewardEvent_zETA_TransferEntityHandlerContext; 
  readonly ZETA_Withdrawal: ZETAContract_ClaimRewardEvent_zETA_WithdrawalEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_handlerContextAsync = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_ClaimRewardEvent_eventsSummaryEntityHandlerContextAsync; 
  readonly ZETA_Approval: ZETAContract_ClaimRewardEvent_zETA_ApprovalEntityHandlerContextAsync; 
  readonly ZETA_ClaimReward: ZETAContract_ClaimRewardEvent_zETA_ClaimRewardEntityHandlerContextAsync; 
  readonly ZETA_Deposit: ZETAContract_ClaimRewardEvent_zETA_DepositEntityHandlerContextAsync; 
  readonly ZETA_NewRewardPool: ZETAContract_ClaimRewardEvent_zETA_NewRewardPoolEntityHandlerContextAsync; 
  readonly ZETA_Transfer: ZETAContract_ClaimRewardEvent_zETA_TransferEntityHandlerContextAsync; 
  readonly ZETA_Withdrawal: ZETAContract_ClaimRewardEvent_zETA_WithdrawalEntityHandlerContextAsync
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_ApprovalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_ClaimRewardEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_DepositEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_NewRewardPoolEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_TransferEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_zETA_WithdrawalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_contractRegistrations = { readonly addZETA: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_ClaimRewardEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: ZETAContract_ClaimRewardEvent_contractRegistrations; 
  readonly EventsSummary: ZETAContract_ClaimRewardEvent_eventsSummaryEntityLoaderContext; 
  readonly ZETA_Approval: ZETAContract_ClaimRewardEvent_zETA_ApprovalEntityLoaderContext; 
  readonly ZETA_ClaimReward: ZETAContract_ClaimRewardEvent_zETA_ClaimRewardEntityLoaderContext; 
  readonly ZETA_Deposit: ZETAContract_ClaimRewardEvent_zETA_DepositEntityLoaderContext; 
  readonly ZETA_NewRewardPool: ZETAContract_ClaimRewardEvent_zETA_NewRewardPoolEntityLoaderContext; 
  readonly ZETA_Transfer: ZETAContract_ClaimRewardEvent_zETA_TransferEntityLoaderContext; 
  readonly ZETA_Withdrawal: ZETAContract_ClaimRewardEvent_zETA_WithdrawalEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_eventArgs = {
  readonly account: Ethers_ethAddress; 
  readonly idx: Ethers_BigInt_t; 
  readonly amount: Ethers_BigInt_t
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_log = eventLog<ZETAContract_DepositEvent_eventArgs>;
export type ZETAContract_Deposit_EventLog = ZETAContract_DepositEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_eventsSummaryEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | eventsSummaryEntity)>; 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_ApprovalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ApprovalEntity); 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_ApprovalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ApprovalEntity)>; 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_ClaimRewardEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ClaimRewardEntity); 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_ClaimRewardEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ClaimRewardEntity)>; 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_DepositEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_DepositEntity); 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_DepositEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_DepositEntity)>; 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_NewRewardPoolEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_NewRewardPoolEntity); 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_NewRewardPoolEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_NewRewardPoolEntity)>; 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_TransferEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_TransferEntity); 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_TransferEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_TransferEntity)>; 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_WithdrawalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_WithdrawalEntity); 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_WithdrawalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_WithdrawalEntity)>; 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_DepositEvent_eventsSummaryEntityHandlerContext; 
  readonly ZETA_Approval: ZETAContract_DepositEvent_zETA_ApprovalEntityHandlerContext; 
  readonly ZETA_ClaimReward: ZETAContract_DepositEvent_zETA_ClaimRewardEntityHandlerContext; 
  readonly ZETA_Deposit: ZETAContract_DepositEvent_zETA_DepositEntityHandlerContext; 
  readonly ZETA_NewRewardPool: ZETAContract_DepositEvent_zETA_NewRewardPoolEntityHandlerContext; 
  readonly ZETA_Transfer: ZETAContract_DepositEvent_zETA_TransferEntityHandlerContext; 
  readonly ZETA_Withdrawal: ZETAContract_DepositEvent_zETA_WithdrawalEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_handlerContextAsync = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_DepositEvent_eventsSummaryEntityHandlerContextAsync; 
  readonly ZETA_Approval: ZETAContract_DepositEvent_zETA_ApprovalEntityHandlerContextAsync; 
  readonly ZETA_ClaimReward: ZETAContract_DepositEvent_zETA_ClaimRewardEntityHandlerContextAsync; 
  readonly ZETA_Deposit: ZETAContract_DepositEvent_zETA_DepositEntityHandlerContextAsync; 
  readonly ZETA_NewRewardPool: ZETAContract_DepositEvent_zETA_NewRewardPoolEntityHandlerContextAsync; 
  readonly ZETA_Transfer: ZETAContract_DepositEvent_zETA_TransferEntityHandlerContextAsync; 
  readonly ZETA_Withdrawal: ZETAContract_DepositEvent_zETA_WithdrawalEntityHandlerContextAsync
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_ApprovalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_ClaimRewardEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_DepositEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_NewRewardPoolEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_TransferEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_zETA_WithdrawalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_contractRegistrations = { readonly addZETA: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_DepositEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: ZETAContract_DepositEvent_contractRegistrations; 
  readonly EventsSummary: ZETAContract_DepositEvent_eventsSummaryEntityLoaderContext; 
  readonly ZETA_Approval: ZETAContract_DepositEvent_zETA_ApprovalEntityLoaderContext; 
  readonly ZETA_ClaimReward: ZETAContract_DepositEvent_zETA_ClaimRewardEntityLoaderContext; 
  readonly ZETA_Deposit: ZETAContract_DepositEvent_zETA_DepositEntityLoaderContext; 
  readonly ZETA_NewRewardPool: ZETAContract_DepositEvent_zETA_NewRewardPoolEntityLoaderContext; 
  readonly ZETA_Transfer: ZETAContract_DepositEvent_zETA_TransferEntityLoaderContext; 
  readonly ZETA_Withdrawal: ZETAContract_DepositEvent_zETA_WithdrawalEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_eventArgs = { readonly rewardPool: Ethers_ethAddress };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_log = eventLog<ZETAContract_NewRewardPoolEvent_eventArgs>;
export type ZETAContract_NewRewardPool_EventLog = ZETAContract_NewRewardPoolEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_eventsSummaryEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | eventsSummaryEntity)>; 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_ApprovalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ApprovalEntity); 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_ApprovalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ApprovalEntity)>; 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_ClaimRewardEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ClaimRewardEntity); 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_ClaimRewardEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ClaimRewardEntity)>; 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_DepositEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_DepositEntity); 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_DepositEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_DepositEntity)>; 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_NewRewardPoolEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_NewRewardPoolEntity); 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_NewRewardPoolEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_NewRewardPoolEntity)>; 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_TransferEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_TransferEntity); 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_TransferEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_TransferEntity)>; 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_WithdrawalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_WithdrawalEntity); 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_WithdrawalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_WithdrawalEntity)>; 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_NewRewardPoolEvent_eventsSummaryEntityHandlerContext; 
  readonly ZETA_Approval: ZETAContract_NewRewardPoolEvent_zETA_ApprovalEntityHandlerContext; 
  readonly ZETA_ClaimReward: ZETAContract_NewRewardPoolEvent_zETA_ClaimRewardEntityHandlerContext; 
  readonly ZETA_Deposit: ZETAContract_NewRewardPoolEvent_zETA_DepositEntityHandlerContext; 
  readonly ZETA_NewRewardPool: ZETAContract_NewRewardPoolEvent_zETA_NewRewardPoolEntityHandlerContext; 
  readonly ZETA_Transfer: ZETAContract_NewRewardPoolEvent_zETA_TransferEntityHandlerContext; 
  readonly ZETA_Withdrawal: ZETAContract_NewRewardPoolEvent_zETA_WithdrawalEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_handlerContextAsync = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_NewRewardPoolEvent_eventsSummaryEntityHandlerContextAsync; 
  readonly ZETA_Approval: ZETAContract_NewRewardPoolEvent_zETA_ApprovalEntityHandlerContextAsync; 
  readonly ZETA_ClaimReward: ZETAContract_NewRewardPoolEvent_zETA_ClaimRewardEntityHandlerContextAsync; 
  readonly ZETA_Deposit: ZETAContract_NewRewardPoolEvent_zETA_DepositEntityHandlerContextAsync; 
  readonly ZETA_NewRewardPool: ZETAContract_NewRewardPoolEvent_zETA_NewRewardPoolEntityHandlerContextAsync; 
  readonly ZETA_Transfer: ZETAContract_NewRewardPoolEvent_zETA_TransferEntityHandlerContextAsync; 
  readonly ZETA_Withdrawal: ZETAContract_NewRewardPoolEvent_zETA_WithdrawalEntityHandlerContextAsync
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_ApprovalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_ClaimRewardEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_DepositEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_NewRewardPoolEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_TransferEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_zETA_WithdrawalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_contractRegistrations = { readonly addZETA: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_NewRewardPoolEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: ZETAContract_NewRewardPoolEvent_contractRegistrations; 
  readonly EventsSummary: ZETAContract_NewRewardPoolEvent_eventsSummaryEntityLoaderContext; 
  readonly ZETA_Approval: ZETAContract_NewRewardPoolEvent_zETA_ApprovalEntityLoaderContext; 
  readonly ZETA_ClaimReward: ZETAContract_NewRewardPoolEvent_zETA_ClaimRewardEntityLoaderContext; 
  readonly ZETA_Deposit: ZETAContract_NewRewardPoolEvent_zETA_DepositEntityLoaderContext; 
  readonly ZETA_NewRewardPool: ZETAContract_NewRewardPoolEvent_zETA_NewRewardPoolEntityLoaderContext; 
  readonly ZETA_Transfer: ZETAContract_NewRewardPoolEvent_zETA_TransferEntityLoaderContext; 
  readonly ZETA_Withdrawal: ZETAContract_NewRewardPoolEvent_zETA_WithdrawalEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_eventArgs = {
  readonly from: Ethers_ethAddress; 
  readonly to: Ethers_ethAddress; 
  readonly value: Ethers_BigInt_t
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_log = eventLog<ZETAContract_TransferEvent_eventArgs>;
export type ZETAContract_Transfer_EventLog = ZETAContract_TransferEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_eventsSummaryEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | eventsSummaryEntity)>; 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_ApprovalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ApprovalEntity); 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_ApprovalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ApprovalEntity)>; 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_ClaimRewardEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ClaimRewardEntity); 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_ClaimRewardEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ClaimRewardEntity)>; 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_DepositEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_DepositEntity); 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_DepositEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_DepositEntity)>; 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_NewRewardPoolEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_NewRewardPoolEntity); 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_NewRewardPoolEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_NewRewardPoolEntity)>; 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_TransferEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_TransferEntity); 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_TransferEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_TransferEntity)>; 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_WithdrawalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_WithdrawalEntity); 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_WithdrawalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_WithdrawalEntity)>; 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_TransferEvent_eventsSummaryEntityHandlerContext; 
  readonly ZETA_Approval: ZETAContract_TransferEvent_zETA_ApprovalEntityHandlerContext; 
  readonly ZETA_ClaimReward: ZETAContract_TransferEvent_zETA_ClaimRewardEntityHandlerContext; 
  readonly ZETA_Deposit: ZETAContract_TransferEvent_zETA_DepositEntityHandlerContext; 
  readonly ZETA_NewRewardPool: ZETAContract_TransferEvent_zETA_NewRewardPoolEntityHandlerContext; 
  readonly ZETA_Transfer: ZETAContract_TransferEvent_zETA_TransferEntityHandlerContext; 
  readonly ZETA_Withdrawal: ZETAContract_TransferEvent_zETA_WithdrawalEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_handlerContextAsync = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_TransferEvent_eventsSummaryEntityHandlerContextAsync; 
  readonly ZETA_Approval: ZETAContract_TransferEvent_zETA_ApprovalEntityHandlerContextAsync; 
  readonly ZETA_ClaimReward: ZETAContract_TransferEvent_zETA_ClaimRewardEntityHandlerContextAsync; 
  readonly ZETA_Deposit: ZETAContract_TransferEvent_zETA_DepositEntityHandlerContextAsync; 
  readonly ZETA_NewRewardPool: ZETAContract_TransferEvent_zETA_NewRewardPoolEntityHandlerContextAsync; 
  readonly ZETA_Transfer: ZETAContract_TransferEvent_zETA_TransferEntityHandlerContextAsync; 
  readonly ZETA_Withdrawal: ZETAContract_TransferEvent_zETA_WithdrawalEntityHandlerContextAsync
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_ApprovalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_ClaimRewardEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_DepositEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_NewRewardPoolEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_TransferEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_zETA_WithdrawalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_contractRegistrations = { readonly addZETA: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_TransferEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: ZETAContract_TransferEvent_contractRegistrations; 
  readonly EventsSummary: ZETAContract_TransferEvent_eventsSummaryEntityLoaderContext; 
  readonly ZETA_Approval: ZETAContract_TransferEvent_zETA_ApprovalEntityLoaderContext; 
  readonly ZETA_ClaimReward: ZETAContract_TransferEvent_zETA_ClaimRewardEntityLoaderContext; 
  readonly ZETA_Deposit: ZETAContract_TransferEvent_zETA_DepositEntityLoaderContext; 
  readonly ZETA_NewRewardPool: ZETAContract_TransferEvent_zETA_NewRewardPoolEntityLoaderContext; 
  readonly ZETA_Transfer: ZETAContract_TransferEvent_zETA_TransferEntityLoaderContext; 
  readonly ZETA_Withdrawal: ZETAContract_TransferEvent_zETA_WithdrawalEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_eventArgs = {
  readonly account: Ethers_ethAddress; 
  readonly idx: Ethers_BigInt_t; 
  readonly amount: Ethers_BigInt_t
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_log = eventLog<ZETAContract_WithdrawalEvent_eventArgs>;
export type ZETAContract_Withdrawal_EventLog = ZETAContract_WithdrawalEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_eventsSummaryEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | eventsSummaryEntity)>; 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_ApprovalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ApprovalEntity); 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_ApprovalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ApprovalEntity)>; 
  readonly set: (_1:zETA_ApprovalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_ClaimRewardEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_ClaimRewardEntity); 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_ClaimRewardEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_ClaimRewardEntity)>; 
  readonly set: (_1:zETA_ClaimRewardEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_DepositEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_DepositEntity); 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_DepositEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_DepositEntity)>; 
  readonly set: (_1:zETA_DepositEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_NewRewardPoolEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_NewRewardPoolEntity); 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_NewRewardPoolEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_NewRewardPoolEntity)>; 
  readonly set: (_1:zETA_NewRewardPoolEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_TransferEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_TransferEntity); 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_TransferEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_TransferEntity)>; 
  readonly set: (_1:zETA_TransferEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_WithdrawalEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | zETA_WithdrawalEntity); 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_WithdrawalEntityHandlerContextAsync = {
  readonly get: (_1:id) => Promise<(undefined | zETA_WithdrawalEntity)>; 
  readonly set: (_1:zETA_WithdrawalEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_WithdrawalEvent_eventsSummaryEntityHandlerContext; 
  readonly ZETA_Approval: ZETAContract_WithdrawalEvent_zETA_ApprovalEntityHandlerContext; 
  readonly ZETA_ClaimReward: ZETAContract_WithdrawalEvent_zETA_ClaimRewardEntityHandlerContext; 
  readonly ZETA_Deposit: ZETAContract_WithdrawalEvent_zETA_DepositEntityHandlerContext; 
  readonly ZETA_NewRewardPool: ZETAContract_WithdrawalEvent_zETA_NewRewardPoolEntityHandlerContext; 
  readonly ZETA_Transfer: ZETAContract_WithdrawalEvent_zETA_TransferEntityHandlerContext; 
  readonly ZETA_Withdrawal: ZETAContract_WithdrawalEvent_zETA_WithdrawalEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_handlerContextAsync = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: ZETAContract_WithdrawalEvent_eventsSummaryEntityHandlerContextAsync; 
  readonly ZETA_Approval: ZETAContract_WithdrawalEvent_zETA_ApprovalEntityHandlerContextAsync; 
  readonly ZETA_ClaimReward: ZETAContract_WithdrawalEvent_zETA_ClaimRewardEntityHandlerContextAsync; 
  readonly ZETA_Deposit: ZETAContract_WithdrawalEvent_zETA_DepositEntityHandlerContextAsync; 
  readonly ZETA_NewRewardPool: ZETAContract_WithdrawalEvent_zETA_NewRewardPoolEntityHandlerContextAsync; 
  readonly ZETA_Transfer: ZETAContract_WithdrawalEvent_zETA_TransferEntityHandlerContextAsync; 
  readonly ZETA_Withdrawal: ZETAContract_WithdrawalEvent_zETA_WithdrawalEntityHandlerContextAsync
};

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_ApprovalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_ClaimRewardEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_DepositEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_NewRewardPoolEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_TransferEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_zETA_WithdrawalEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_contractRegistrations = { readonly addZETA: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type ZETAContract_WithdrawalEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: ZETAContract_WithdrawalEvent_contractRegistrations; 
  readonly EventsSummary: ZETAContract_WithdrawalEvent_eventsSummaryEntityLoaderContext; 
  readonly ZETA_Approval: ZETAContract_WithdrawalEvent_zETA_ApprovalEntityLoaderContext; 
  readonly ZETA_ClaimReward: ZETAContract_WithdrawalEvent_zETA_ClaimRewardEntityLoaderContext; 
  readonly ZETA_Deposit: ZETAContract_WithdrawalEvent_zETA_DepositEntityLoaderContext; 
  readonly ZETA_NewRewardPool: ZETAContract_WithdrawalEvent_zETA_NewRewardPoolEntityLoaderContext; 
  readonly ZETA_Transfer: ZETAContract_WithdrawalEvent_zETA_TransferEntityLoaderContext; 
  readonly ZETA_Withdrawal: ZETAContract_WithdrawalEvent_zETA_WithdrawalEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type chainId = number;
