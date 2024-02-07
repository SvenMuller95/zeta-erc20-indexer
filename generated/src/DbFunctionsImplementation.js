// db operations for raw_events:
const MAX_ITEMS_PER_QUERY = 500;

module.exports.readLatestSyncedEventOnChainId = (sql, chainId) => sql`
  SELECT *
  FROM public.event_sync_state
  WHERE chain_id = ${chainId}`;

module.exports.batchSetEventSyncState = (sql, entityDataArray) => {
  return sql`
    INSERT INTO public.event_sync_state
  ${sql(
    entityDataArray,
    "chain_id",
    "block_number",
    "log_index",
    "transaction_index",
    "block_timestamp"
  )}
    ON CONFLICT(chain_id) DO UPDATE
    SET
    "chain_id" = EXCLUDED."chain_id",
    "block_number" = EXCLUDED."block_number",
    "log_index" = EXCLUDED."log_index",
    "transaction_index" = EXCLUDED."transaction_index",
    "block_timestamp" = EXCLUDED."block_timestamp";
    `;
};

module.exports.setChainMetadata = (sql, entityDataArray) => {
  return (sql`
    INSERT INTO public.chain_metadata
  ${sql(
    entityDataArray,
    "chain_id",
    "start_block", // this is left out of the on conflict below as it only needs to be set once
    "block_height"
  )}
  ON CONFLICT(chain_id) DO UPDATE
  SET
  "chain_id" = EXCLUDED."chain_id",
  "block_height" = EXCLUDED."block_height";`).then(res => {
    
  }).catch(err => {
    console.log("errored", err)
  });
};

module.exports.readLatestRawEventsBlockNumberProcessedOnChainId = (
  sql,
  chainId
) => sql`
  SELECT block_number
  FROM "public"."raw_events"
  WHERE chain_id = ${chainId}
  ORDER BY event_id DESC
  LIMIT 1;`;

module.exports.readRawEventsEntities = (sql, entityIdArray) => sql`
  SELECT *
  FROM "public"."raw_events"
  WHERE (chain_id, event_id) IN ${sql(entityIdArray)}`;

module.exports.getRawEventsPageGtOrEqEventId = (
  sql,
  chainId,
  eventId,
  limit,
  contractAddresses
) => sql`
  SELECT *
  FROM "public"."raw_events"
  WHERE "chain_id" = ${chainId}
  AND "event_id" >= ${eventId}
  AND "src_address" IN ${sql(contractAddresses)}
  ORDER BY "event_id" ASC
  LIMIT ${limit}
`;

module.exports.getRawEventsPageWithinEventIdRangeInclusive = (
  sql,
  chainId,
  fromEventIdInclusive,
  toEventIdInclusive,
  limit,
  contractAddresses
) => sql`
  SELECT *
  FROM public.raw_events
  WHERE "chain_id" = ${chainId}
  AND "event_id" >= ${fromEventIdInclusive}
  AND "event_id" <= ${toEventIdInclusive}
  AND "src_address" IN ${sql(contractAddresses)}
  ORDER BY "event_id" ASC
  LIMIT ${limit}
`;

const batchSetRawEventsCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."raw_events"
  ${sql(
    entityDataArray,
    "chain_id",
    "event_id",
    "block_number",
    "log_index",
    "transaction_index",
    "transaction_hash",
    "src_address",
    "block_hash",
    "block_timestamp",
    "event_type",
    "params"
  )}
    ON CONFLICT(chain_id, event_id) DO UPDATE
    SET
    "chain_id" = EXCLUDED."chain_id",
    "event_id" = EXCLUDED."event_id",
    "block_number" = EXCLUDED."block_number",
    "log_index" = EXCLUDED."log_index",
    "transaction_index" = EXCLUDED."transaction_index",
    "transaction_hash" = EXCLUDED."transaction_hash",
    "src_address" = EXCLUDED."src_address",
    "block_hash" = EXCLUDED."block_hash",
    "block_timestamp" = EXCLUDED."block_timestamp",
    "event_type" = EXCLUDED."event_type",
    "params" = EXCLUDED."params";`;
};

const chunkBatchQuery = (
  sql,
  entityDataArray,
  queryToExecute
) => {
  const promises = [];

  // Split entityDataArray into chunks of MAX_ITEMS_PER_QUERY
  for (let i = 0; i < entityDataArray.length; i += MAX_ITEMS_PER_QUERY) {
    const chunk = entityDataArray.slice(i, i + MAX_ITEMS_PER_QUERY);

    promises.push(queryToExecute(sql, chunk));
  }

  // Execute all promises
  return Promise.all(promises).catch(e => {
    console.error("Sql query failed", e);
    throw e;
    });
};

module.exports.batchSetRawEvents = (sql, entityDataArray) => {
  return chunkBatchQuery(
    sql,
    entityDataArray,
    batchSetRawEventsCore
  );
};

module.exports.batchDeleteRawEvents = (sql, entityIdArray) => sql`
  DELETE
  FROM "public"."raw_events"
  WHERE (chain_id, event_id) IN ${sql(entityIdArray)};`;
// end db operations for raw_events

module.exports.readDynamicContractsOnChainIdAtOrBeforeBlock = (
  sql,
  chainId,
  block_number
) => sql`
  SELECT c.contract_address, c.contract_type, c.event_id
  FROM "public"."dynamic_contract_registry" as c
  JOIN raw_events e ON c.chain_id = e.chain_id
  AND c.event_id = e.event_id
  WHERE e.block_number <= ${block_number} AND e.chain_id = ${chainId};`;

//Start db operations dynamic_contract_registry
module.exports.readDynamicContractRegistryEntities = (
  sql,
  entityIdArray
) => sql`
  SELECT *
  FROM "public"."dynamic_contract_registry"
  WHERE (chain_id, contract_address) IN ${sql(entityIdArray)}`;

const batchSetDynamicContractRegistryCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."dynamic_contract_registry"
  ${sql(
    entityDataArray,
    "chain_id",
    "event_id",
    "contract_address",
    "contract_type"
  )}
    ON CONFLICT(chain_id, contract_address) DO UPDATE
    SET
    "chain_id" = EXCLUDED."chain_id",
    "event_id" = EXCLUDED."event_id",
    "contract_address" = EXCLUDED."contract_address",
    "contract_type" = EXCLUDED."contract_type";`;
};

module.exports.batchSetDynamicContractRegistry = (sql, entityDataArray) => {
  return chunkBatchQuery(
    sql,
    entityDataArray,
    batchSetDynamicContractRegistryCore
  );
};

module.exports.batchDeleteDynamicContractRegistry = (sql, entityIdArray) => sql`
  DELETE
  FROM "public"."dynamic_contract_registry"
  WHERE (chain_id, contract_address) IN ${sql(entityIdArray)};`;
// end db operations for dynamic_contract_registry

//////////////////////////////////////////////
// DB operations for EventsSummary:
//////////////////////////////////////////////

module.exports.readEventsSummaryEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"zETA_ApprovalCount",
"zETA_ClaimRewardCount",
"zETA_DepositCount",
"zETA_NewRewardPoolCount",
"zETA_TransferCount",
"zETA_WithdrawalCount"
FROM "public"."EventsSummary"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetEventsSummaryCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."EventsSummary"
${sql(entityDataArray,
    "id",
    "zETA_ApprovalCount",
    "zETA_ClaimRewardCount",
    "zETA_DepositCount",
    "zETA_NewRewardPoolCount",
    "zETA_TransferCount",
    "zETA_WithdrawalCount"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "zETA_ApprovalCount" = EXCLUDED."zETA_ApprovalCount",
  "zETA_ClaimRewardCount" = EXCLUDED."zETA_ClaimRewardCount",
  "zETA_DepositCount" = EXCLUDED."zETA_DepositCount",
  "zETA_NewRewardPoolCount" = EXCLUDED."zETA_NewRewardPoolCount",
  "zETA_TransferCount" = EXCLUDED."zETA_TransferCount",
  "zETA_WithdrawalCount" = EXCLUDED."zETA_WithdrawalCount"
  `;
}

module.exports.batchSetEventsSummary = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetEventsSummaryCore
  );
}

module.exports.batchDeleteEventsSummary = (sql, entityIdArray) => sql`
DELETE
FROM "public"."EventsSummary"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for EventsSummary

//////////////////////////////////////////////
// DB operations for ZETA_Approval:
//////////////////////////////////////////////

module.exports.readZETA_ApprovalEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"owner",
"spender",
"value",
"eventsSummary"
FROM "public"."ZETA_Approval"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetZETA_ApprovalCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."ZETA_Approval"
${sql(entityDataArray,
    "id",
    "owner",
    "spender",
    "value",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "owner" = EXCLUDED."owner",
  "spender" = EXCLUDED."spender",
  "value" = EXCLUDED."value",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetZETA_Approval = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetZETA_ApprovalCore
  );
}

module.exports.batchDeleteZETA_Approval = (sql, entityIdArray) => sql`
DELETE
FROM "public"."ZETA_Approval"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for ZETA_Approval

//////////////////////////////////////////////
// DB operations for ZETA_ClaimReward:
//////////////////////////////////////////////

module.exports.readZETA_ClaimRewardEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"account",
"idx",
"amount",
"eventsSummary"
FROM "public"."ZETA_ClaimReward"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetZETA_ClaimRewardCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."ZETA_ClaimReward"
${sql(entityDataArray,
    "id",
    "account",
    "idx",
    "amount",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "account" = EXCLUDED."account",
  "idx" = EXCLUDED."idx",
  "amount" = EXCLUDED."amount",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetZETA_ClaimReward = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetZETA_ClaimRewardCore
  );
}

module.exports.batchDeleteZETA_ClaimReward = (sql, entityIdArray) => sql`
DELETE
FROM "public"."ZETA_ClaimReward"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for ZETA_ClaimReward

//////////////////////////////////////////////
// DB operations for ZETA_Deposit:
//////////////////////////////////////////////

module.exports.readZETA_DepositEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"account",
"idx",
"amount",
"eventsSummary"
FROM "public"."ZETA_Deposit"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetZETA_DepositCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."ZETA_Deposit"
${sql(entityDataArray,
    "id",
    "account",
    "idx",
    "amount",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "account" = EXCLUDED."account",
  "idx" = EXCLUDED."idx",
  "amount" = EXCLUDED."amount",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetZETA_Deposit = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetZETA_DepositCore
  );
}

module.exports.batchDeleteZETA_Deposit = (sql, entityIdArray) => sql`
DELETE
FROM "public"."ZETA_Deposit"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for ZETA_Deposit

//////////////////////////////////////////////
// DB operations for ZETA_NewRewardPool:
//////////////////////////////////////////////

module.exports.readZETA_NewRewardPoolEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"rewardPool",
"eventsSummary"
FROM "public"."ZETA_NewRewardPool"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetZETA_NewRewardPoolCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."ZETA_NewRewardPool"
${sql(entityDataArray,
    "id",
    "rewardPool",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "rewardPool" = EXCLUDED."rewardPool",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetZETA_NewRewardPool = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetZETA_NewRewardPoolCore
  );
}

module.exports.batchDeleteZETA_NewRewardPool = (sql, entityIdArray) => sql`
DELETE
FROM "public"."ZETA_NewRewardPool"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for ZETA_NewRewardPool

//////////////////////////////////////////////
// DB operations for ZETA_Transfer:
//////////////////////////////////////////////

module.exports.readZETA_TransferEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"from",
"to",
"value",
"eventsSummary"
FROM "public"."ZETA_Transfer"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetZETA_TransferCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."ZETA_Transfer"
${sql(entityDataArray,
    "id",
    "from",
    "to",
    "value",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "from" = EXCLUDED."from",
  "to" = EXCLUDED."to",
  "value" = EXCLUDED."value",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetZETA_Transfer = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetZETA_TransferCore
  );
}

module.exports.batchDeleteZETA_Transfer = (sql, entityIdArray) => sql`
DELETE
FROM "public"."ZETA_Transfer"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for ZETA_Transfer

//////////////////////////////////////////////
// DB operations for ZETA_Withdrawal:
//////////////////////////////////////////////

module.exports.readZETA_WithdrawalEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"account",
"idx",
"amount",
"eventsSummary"
FROM "public"."ZETA_Withdrawal"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetZETA_WithdrawalCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."ZETA_Withdrawal"
${sql(entityDataArray,
    "id",
    "account",
    "idx",
    "amount",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "account" = EXCLUDED."account",
  "idx" = EXCLUDED."idx",
  "amount" = EXCLUDED."amount",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetZETA_Withdrawal = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetZETA_WithdrawalCore
  );
}

module.exports.batchDeleteZETA_Withdrawal = (sql, entityIdArray) => sql`
DELETE
FROM "public"."ZETA_Withdrawal"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for ZETA_Withdrawal

