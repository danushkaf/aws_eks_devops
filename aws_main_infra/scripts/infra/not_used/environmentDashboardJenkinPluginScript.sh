#!/bin/bash

exit_status=0
output=$(curl -H "x-api-key:$API_KEY" $HEALTHCHECK_API)

echo "=============Client service status ================"
echo $output | jq '.clientService'
CLIENT_SERVICE_STATUS=$(echo $output | jq '.clientService.statusText' | xargs)
CLIENT_SERVICE_STATUS_CODE=$(echo $output | jq '.clientService.status' | xargs)
echo CLIENT_SERVICE_STATUS="${CLIENT_SERVICE_STATUS}" >> var.properties
if [[ "$CLIENT_SERVICE_STATUS_CODE" -ne 200 ]]; then
  exit_status=$((exit_status + 1))
fi

echo "=============Account service status ================"
echo $output | jq '.accountService'
ACCOUNT_SERVICE_STATUS=$(echo $output | jq '.accountService.statusText' | xargs)
ACCOUNT_SERVICE_STATUS_CODE=$(echo $output | jq '.accountService.status' | xargs)
echo ACCOUNT_SERVICE_STATUS="${ACCOUNT_SERVICE_STATUS}" >> var.properties
if [[ "$ACCOUNT_SERVICE_STATUS_CODE" -ne 200 ]]; then
  exit_status=$((exit_status + 1))
fi

echo "=============Document service status ================"
echo $output | jq '.documentService'
DOCUMENT_SERVICE_STATUS=$(echo $output | jq '.documentService.statusText' | xargs)
DOCUMENT_SERVICE_STATUS_CODE=$(echo $output | jq '.documentService.status' | xargs)
echo DOCUMENT_SERVICE_STATUS="${DOCUMENT_SERVICE_STATUS}" >> var.properties
if [[ "$DOCUMENT_SERVICE_STATUS_CODE" -ne 200 ]]; then
  exit_status=$((exit_status + 1))
fi

echo "============Notification service status ================"
echo $output | jq '.notificationService'
NOTIFICATION_SERVICE_STATUS=$(echo $output | jq '.notificationService.statusText' | xargs)
NOTIFICATION_SERVICE_STATUS_CODE=$(echo $output | jq '.notificationService.status' | xargs)
echo NOTIFICATION_SERVICE_STATUS="${NOTIFICATION_SERVICE_STATUS}" >> var.properties
if [[ "$NOTIFICATION_SERVICE_STATUS_CODE" -ne 200 ]]; then
  exit_status=$((exit_status + 1))
fi

echo "============Payment service status ================"
echo $output | jq '.paymentService'
PAYMENT_SERVICE_STATUS=$(echo $output | jq '.paymentService.statusText' | xargs)
PAYMENT_SERVICE_STATUS_CODE=$(echo $output | jq '.paymentService.status' | xargs)
echo PAYMENT_SERVICE_STATUS="${PAYMENT_SERVICE_STATUS}" >> var.properties
if [[ "$PAYMENT_SERVICE_STATUS_CODE" -ne 200 ]]; then
  exit_status=$((exit_status + 1))
fi

echo "============Product service status ================"
echo $output | jq '.productService'
PRODUCT_SERVICE_STATUS=$(echo $output | jq '.productService.statusText' | xargs)
PRODUCT_SERVICE_STATUS_CODE=$(echo $output | jq '.productService.status' | xargs)
echo PRODUCT_SERVICE_STATUS="${PRODUCT_SERVICE_STATUS}" >> var.properties
if [[ "$PRODUCT_SERVICE_STATUS_CODE" -ne 200 ]]; then
  exit_status=$((exit_status + 1))
fi

echo "============SFIntegration service status ================"
echo $output | jq '.sfintegrationService'
SFINT_SERVICE_STATUS=$(echo $output | jq '.sfintegrationService.statusText' | xargs)
SFINT_SERVICE_STATUS_CODE=$(echo $output | jq '.sfintegrationService.status' | xargs)
echo SFINT_SERVICE_STATUS="${SFINT_SERVICE_STATUS}" >> var.properties
if [[ "$SFINT_SERVICE_STATUS_CODE" -ne 200 ]]; then
  exit_status=$((exit_status + 1))
fi

ENVIRONMENT_STATUS="Healthy"
if [ "$exit_status" -eq 1 ]; then
  ENVIRONMENT_STATUS="Unstable"
elif [ "$exit_status" -gt 1 ]; then
  ENVIRONMENT_STATUS="Unhealthy"
fi
echo ENVIRONMENT_STATUS="${ENVIRONMENT_STATUS}" >> var.properties
echo exit_status="${exit_status}" >> var.properties