/* TypeScript file generated from IO.res by genType. */
/* eslint-disable import/first */


import type {EventSyncState_eventSyncState as DbFunctions_EventSyncState_eventSyncState} from './DbFunctions.gen';

import type {ethAddress as Ethers_ethAddress} from '../src/bindings/Ethers.gen';

import type {inMemoryStoreRow as Types_inMemoryStoreRow} from './Types.gen';

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_stringHasher<val> = (_1:val) => string;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_storeState<entity,entityKey> = { readonly dict: {[id: string]: Types_inMemoryStoreRow<entity>}; readonly hasher: InMemoryStore_stringHasher<entityKey> };

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_EventSyncState_value = DbFunctions_EventSyncState_eventSyncState;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_EventSyncState_key = number;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_EventSyncState_t = InMemoryStore_storeState<InMemoryStore_EventSyncState_value,InMemoryStore_EventSyncState_key>;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_rawEventsKey = { readonly chainId: number; readonly eventId: string };

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_RawEvents_t = InMemoryStore_storeState<InMemoryStore_RawEvents_value,InMemoryStore_RawEvents_key>;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_dynamicContractRegistryKey = { readonly chainId: number; readonly contractAddress: Ethers_ethAddress };

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_DynamicContractRegistry_t = InMemoryStore_storeState<InMemoryStore_DynamicContractRegistry_value,InMemoryStore_DynamicContractRegistry_key>;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_EventsSummary_t = InMemoryStore_storeState<InMemoryStore_EventsSummary_value,InMemoryStore_EventsSummary_key>;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_ZETA_Approval_t = InMemoryStore_storeState<InMemoryStore_ZETA_Approval_value,InMemoryStore_ZETA_Approval_key>;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_ZETA_ClaimReward_t = InMemoryStore_storeState<InMemoryStore_ZETA_ClaimReward_value,InMemoryStore_ZETA_ClaimReward_key>;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_ZETA_Deposit_t = InMemoryStore_storeState<InMemoryStore_ZETA_Deposit_value,InMemoryStore_ZETA_Deposit_key>;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_ZETA_NewRewardPool_t = InMemoryStore_storeState<InMemoryStore_ZETA_NewRewardPool_value,InMemoryStore_ZETA_NewRewardPool_key>;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_ZETA_Transfer_t = InMemoryStore_storeState<InMemoryStore_ZETA_Transfer_value,InMemoryStore_ZETA_Transfer_key>;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_ZETA_Withdrawal_t = InMemoryStore_storeState<InMemoryStore_ZETA_Withdrawal_value,InMemoryStore_ZETA_Withdrawal_key>;

// tslint:disable-next-line:interface-over-type-literal
export type InMemoryStore_t = {
  readonly eventSyncState: InMemoryStore_EventSyncState_t; 
  readonly rawEvents: InMemoryStore_RawEvents_t; 
  readonly dynamicContractRegistry: InMemoryStore_DynamicContractRegistry_t; 
  readonly eventsSummary: InMemoryStore_EventsSummary_t; 
  readonly zETA_Approval: InMemoryStore_ZETA_Approval_t; 
  readonly zETA_ClaimReward: InMemoryStore_ZETA_ClaimReward_t; 
  readonly zETA_Deposit: InMemoryStore_ZETA_Deposit_t; 
  readonly zETA_NewRewardPool: InMemoryStore_ZETA_NewRewardPool_t; 
  readonly zETA_Transfer: InMemoryStore_ZETA_Transfer_t; 
  readonly zETA_Withdrawal: InMemoryStore_ZETA_Withdrawal_t
};
