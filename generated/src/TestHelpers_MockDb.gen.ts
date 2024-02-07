/* TypeScript file generated from TestHelpers_MockDb.res by genType. */
/* eslint-disable import/first */


// @ts-ignore: Implicit any on import
const TestHelpers_MockDbBS = require('./TestHelpers_MockDb.bs');

import type {EventSyncState_eventSyncState as DbFunctions_EventSyncState_eventSyncState} from './DbFunctions.gen';

import type {InMemoryStore_dynamicContractRegistryKey as IO_InMemoryStore_dynamicContractRegistryKey} from './IO.gen';

import type {InMemoryStore_rawEventsKey as IO_InMemoryStore_rawEventsKey} from './IO.gen';

import type {InMemoryStore_t as IO_InMemoryStore_t} from './IO.gen';

import type {chainId as Types_chainId} from './Types.gen';

import type {dynamicContractRegistryEntity as Types_dynamicContractRegistryEntity} from './Types.gen';

import type {eventsSummaryEntity as Types_eventsSummaryEntity} from './Types.gen';

import type {rawEventsEntity as Types_rawEventsEntity} from './Types.gen';

import type {zETA_ApprovalEntity as Types_zETA_ApprovalEntity} from './Types.gen';

import type {zETA_ClaimRewardEntity as Types_zETA_ClaimRewardEntity} from './Types.gen';

import type {zETA_DepositEntity as Types_zETA_DepositEntity} from './Types.gen';

import type {zETA_NewRewardPoolEntity as Types_zETA_NewRewardPoolEntity} from './Types.gen';

import type {zETA_TransferEntity as Types_zETA_TransferEntity} from './Types.gen';

import type {zETA_WithdrawalEntity as Types_zETA_WithdrawalEntity} from './Types.gen';

// tslint:disable-next-line:interface-over-type-literal
export type t = {
  readonly __dbInternal__: IO_InMemoryStore_t; 
  readonly entities: entities; 
  readonly rawEvents: storeOperations<IO_InMemoryStore_rawEventsKey,Types_rawEventsEntity>; 
  readonly eventSyncState: storeOperations<Types_chainId,DbFunctions_EventSyncState_eventSyncState>; 
  readonly dynamicContractRegistry: storeOperations<IO_InMemoryStore_dynamicContractRegistryKey,Types_dynamicContractRegistryEntity>
};

// tslint:disable-next-line:interface-over-type-literal
export type entities = {
  readonly EventsSummary: entityStoreOperations<Types_eventsSummaryEntity>; 
  readonly ZETA_Approval: entityStoreOperations<Types_zETA_ApprovalEntity>; 
  readonly ZETA_ClaimReward: entityStoreOperations<Types_zETA_ClaimRewardEntity>; 
  readonly ZETA_Deposit: entityStoreOperations<Types_zETA_DepositEntity>; 
  readonly ZETA_NewRewardPool: entityStoreOperations<Types_zETA_NewRewardPoolEntity>; 
  readonly ZETA_Transfer: entityStoreOperations<Types_zETA_TransferEntity>; 
  readonly ZETA_Withdrawal: entityStoreOperations<Types_zETA_WithdrawalEntity>
};

// tslint:disable-next-line:interface-over-type-literal
export type entityStoreOperations<entity> = storeOperations<string,entity>;

// tslint:disable-next-line:interface-over-type-literal
export type storeOperations<entityKey,entity> = {
  readonly getAll: () => entity[]; 
  readonly get: (_1:entityKey) => (undefined | entity); 
  readonly set: (_1:entity) => t; 
  readonly delete: (_1:entityKey) => t
};

export const createMockDb: () => t = TestHelpers_MockDbBS.createMockDb;
