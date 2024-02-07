/* TypeScript file generated from Handlers.res by genType. */
/* eslint-disable import/first */


// @ts-ignore: Implicit any on import
const Curry = require('rescript/lib/js/curry.js');

// @ts-ignore: Implicit any on import
const HandlersBS = require('./Handlers.bs');

import type {ZETAContract_ApprovalEvent_eventArgs as Types_ZETAContract_ApprovalEvent_eventArgs} from './Types.gen';

import type {ZETAContract_ApprovalEvent_handlerContextAsync as Types_ZETAContract_ApprovalEvent_handlerContextAsync} from './Types.gen';

import type {ZETAContract_ApprovalEvent_handlerContext as Types_ZETAContract_ApprovalEvent_handlerContext} from './Types.gen';

import type {ZETAContract_ApprovalEvent_loaderContext as Types_ZETAContract_ApprovalEvent_loaderContext} from './Types.gen';

import type {ZETAContract_ClaimRewardEvent_eventArgs as Types_ZETAContract_ClaimRewardEvent_eventArgs} from './Types.gen';

import type {ZETAContract_ClaimRewardEvent_handlerContextAsync as Types_ZETAContract_ClaimRewardEvent_handlerContextAsync} from './Types.gen';

import type {ZETAContract_ClaimRewardEvent_handlerContext as Types_ZETAContract_ClaimRewardEvent_handlerContext} from './Types.gen';

import type {ZETAContract_ClaimRewardEvent_loaderContext as Types_ZETAContract_ClaimRewardEvent_loaderContext} from './Types.gen';

import type {ZETAContract_DepositEvent_eventArgs as Types_ZETAContract_DepositEvent_eventArgs} from './Types.gen';

import type {ZETAContract_DepositEvent_handlerContextAsync as Types_ZETAContract_DepositEvent_handlerContextAsync} from './Types.gen';

import type {ZETAContract_DepositEvent_handlerContext as Types_ZETAContract_DepositEvent_handlerContext} from './Types.gen';

import type {ZETAContract_DepositEvent_loaderContext as Types_ZETAContract_DepositEvent_loaderContext} from './Types.gen';

import type {ZETAContract_NewRewardPoolEvent_eventArgs as Types_ZETAContract_NewRewardPoolEvent_eventArgs} from './Types.gen';

import type {ZETAContract_NewRewardPoolEvent_handlerContextAsync as Types_ZETAContract_NewRewardPoolEvent_handlerContextAsync} from './Types.gen';

import type {ZETAContract_NewRewardPoolEvent_handlerContext as Types_ZETAContract_NewRewardPoolEvent_handlerContext} from './Types.gen';

import type {ZETAContract_NewRewardPoolEvent_loaderContext as Types_ZETAContract_NewRewardPoolEvent_loaderContext} from './Types.gen';

import type {ZETAContract_TransferEvent_eventArgs as Types_ZETAContract_TransferEvent_eventArgs} from './Types.gen';

import type {ZETAContract_TransferEvent_handlerContextAsync as Types_ZETAContract_TransferEvent_handlerContextAsync} from './Types.gen';

import type {ZETAContract_TransferEvent_handlerContext as Types_ZETAContract_TransferEvent_handlerContext} from './Types.gen';

import type {ZETAContract_TransferEvent_loaderContext as Types_ZETAContract_TransferEvent_loaderContext} from './Types.gen';

import type {ZETAContract_WithdrawalEvent_eventArgs as Types_ZETAContract_WithdrawalEvent_eventArgs} from './Types.gen';

import type {ZETAContract_WithdrawalEvent_handlerContextAsync as Types_ZETAContract_WithdrawalEvent_handlerContextAsync} from './Types.gen';

import type {ZETAContract_WithdrawalEvent_handlerContext as Types_ZETAContract_WithdrawalEvent_handlerContext} from './Types.gen';

import type {ZETAContract_WithdrawalEvent_loaderContext as Types_ZETAContract_WithdrawalEvent_loaderContext} from './Types.gen';

import type {eventLog as Types_eventLog} from './Types.gen';

import type {genericContextCreatorFunctions as Context_genericContextCreatorFunctions} from './Context.gen';

import type {t as SyncAsync_t} from './SyncAsync.gen';

// tslint:disable-next-line:interface-over-type-literal
export type handlerFunction<eventArgs,context,returned> = (_1:{ readonly event: Types_eventLog<eventArgs>; readonly context: context }) => returned;

// tslint:disable-next-line:interface-over-type-literal
export type handlerWithContextGetter<eventArgs,context,returned,loaderContext,handlerContextSync,handlerContextAsync> = { readonly handler: handlerFunction<eventArgs,context,returned>; readonly contextGetter: (_1:Context_genericContextCreatorFunctions<loaderContext,handlerContextSync,handlerContextAsync>) => context };

// tslint:disable-next-line:interface-over-type-literal
export type handlerWithContextGetterSyncAsync<eventArgs,loaderContext,handlerContextSync,handlerContextAsync> = SyncAsync_t<handlerWithContextGetter<eventArgs,handlerContextSync,void,loaderContext,handlerContextSync,handlerContextAsync>,handlerWithContextGetter<eventArgs,handlerContextAsync,Promise<void>,loaderContext,handlerContextSync,handlerContextAsync>>;

// tslint:disable-next-line:interface-over-type-literal
export type loader<eventArgs,loaderContext> = (_1:{ readonly event: Types_eventLog<eventArgs>; readonly context: loaderContext }) => void;

export const ZETAContract_Approval_loader: (loader:loader<Types_ZETAContract_ApprovalEvent_eventArgs,Types_ZETAContract_ApprovalEvent_loaderContext>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Approval.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Approval_handler: (handler:handlerFunction<Types_ZETAContract_ApprovalEvent_eventArgs,Types_ZETAContract_ApprovalEvent_handlerContext,void>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Approval.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Approval_handlerAsync: (handler:handlerFunction<Types_ZETAContract_ApprovalEvent_eventArgs,Types_ZETAContract_ApprovalEvent_handlerContextAsync,Promise<void>>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Approval.handlerAsync(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_ClaimReward_loader: (loader:loader<Types_ZETAContract_ClaimRewardEvent_eventArgs,Types_ZETAContract_ClaimRewardEvent_loaderContext>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.ClaimReward.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_ClaimReward_handler: (handler:handlerFunction<Types_ZETAContract_ClaimRewardEvent_eventArgs,Types_ZETAContract_ClaimRewardEvent_handlerContext,void>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.ClaimReward.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_ClaimReward_handlerAsync: (handler:handlerFunction<Types_ZETAContract_ClaimRewardEvent_eventArgs,Types_ZETAContract_ClaimRewardEvent_handlerContextAsync,Promise<void>>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.ClaimReward.handlerAsync(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Deposit_loader: (loader:loader<Types_ZETAContract_DepositEvent_eventArgs,Types_ZETAContract_DepositEvent_loaderContext>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Deposit.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Deposit_handler: (handler:handlerFunction<Types_ZETAContract_DepositEvent_eventArgs,Types_ZETAContract_DepositEvent_handlerContext,void>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Deposit.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Deposit_handlerAsync: (handler:handlerFunction<Types_ZETAContract_DepositEvent_eventArgs,Types_ZETAContract_DepositEvent_handlerContextAsync,Promise<void>>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Deposit.handlerAsync(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_NewRewardPool_loader: (loader:loader<Types_ZETAContract_NewRewardPoolEvent_eventArgs,Types_ZETAContract_NewRewardPoolEvent_loaderContext>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.NewRewardPool.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_NewRewardPool_handler: (handler:handlerFunction<Types_ZETAContract_NewRewardPoolEvent_eventArgs,Types_ZETAContract_NewRewardPoolEvent_handlerContext,void>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.NewRewardPool.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_NewRewardPool_handlerAsync: (handler:handlerFunction<Types_ZETAContract_NewRewardPoolEvent_eventArgs,Types_ZETAContract_NewRewardPoolEvent_handlerContextAsync,Promise<void>>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.NewRewardPool.handlerAsync(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Transfer_loader: (loader:loader<Types_ZETAContract_TransferEvent_eventArgs,Types_ZETAContract_TransferEvent_loaderContext>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Transfer.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Transfer_handler: (handler:handlerFunction<Types_ZETAContract_TransferEvent_eventArgs,Types_ZETAContract_TransferEvent_handlerContext,void>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Transfer.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Transfer_handlerAsync: (handler:handlerFunction<Types_ZETAContract_TransferEvent_eventArgs,Types_ZETAContract_TransferEvent_handlerContextAsync,Promise<void>>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Transfer.handlerAsync(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Withdrawal_loader: (loader:loader<Types_ZETAContract_WithdrawalEvent_eventArgs,Types_ZETAContract_WithdrawalEvent_loaderContext>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Withdrawal.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Withdrawal_handler: (handler:handlerFunction<Types_ZETAContract_WithdrawalEvent_eventArgs,Types_ZETAContract_WithdrawalEvent_handlerContext,void>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Withdrawal.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};

export const ZETAContract_Withdrawal_handlerAsync: (handler:handlerFunction<Types_ZETAContract_WithdrawalEvent_eventArgs,Types_ZETAContract_WithdrawalEvent_handlerContextAsync,Promise<void>>) => void = function (Arg1: any) {
  const result = HandlersBS.ZETAContract.Withdrawal.handlerAsync(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, ZETA_Approval:Argcontext.ZETA_Approval, ZETA_ClaimReward:Argcontext.ZETA_ClaimReward, ZETA_Deposit:Argcontext.ZETA_Deposit, ZETA_NewRewardPool:Argcontext.ZETA_NewRewardPool, ZETA_Transfer:Argcontext.ZETA_Transfer, ZETA_Withdrawal:Argcontext.ZETA_Withdrawal}});
      return result1
    });
  return result
};
