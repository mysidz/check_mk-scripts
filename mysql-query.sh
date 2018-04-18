#!/bin/bash
## MySQL Custom Test - Siddiq

## Changeable variables. Change only variables inside here (!!)
# Thresholds in percentage
warning=1
critical=2

# MySQL Command. Remember testname should not contain any space
testname=CVPBalanceMismatch
command='SELECT CA.`ACCOUNT_ID` AS "Account Id", rpt.`account_code` AS "Company Code", rpt.`account_name` AS "Company Name", NOW() AS "Opening Balance Date", CA.`BALANCE` AS "Opening Balance", rpt.`balance_date` AS "Closing Balance Date", rpt.`balance` AS "Closing Balance" FROM ycms.CVP_ACCOUNT CA, ycms.`rpt_account_daily_balance_mv` rpt WHERE CA.`ACCOUNT_ID` = rpt.`account_id` AND CA.`BALANCE` != rpt.`balance` AND rpt.`balance_date` = DATE(DATE_SUB(NOW(), INTERVAL 1 DAY));'

## Static variables & calculations
mysql=$(which mysql)
woot=$($mysql --defaults-extra-file=/usr/lib/check_mk_agent/mysql.conf --batch -N --silent -e "$command" | wc -l)

# Thresholds going downwards or upwards?. Comment/Uncomment whichever is necessary
how=gt # Upwards - Example: Warning 80%, Critical 90%

## Functions

if [ $woot -$how $critical ] ; then
        status=2
elif [ $woot -$how $warning ] ; then
        status=1
else
        status=0
fi

## Output

echo "$status MySQL-$testname sqlresult=$woot;$warning;$critical;0; SQL Output is $woot. (Warning $warning, Critical $critical)"
