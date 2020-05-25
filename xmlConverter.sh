#!/bin/bash
#
# xmlConverter.sh
# To convert Hyperic Alert Definition XML format to CSV format.
# Created by Tepnimit Lakkanapantip - 11/28/2017
#
HOME=/home/ted/myScript/AlertDefinition
INPUT_PATH_DEFAULT="$HOME/allAlertDefinition.xml"
read -p "Please enter XML file [$INPUT_PATH_DEFAULT]: " IN_PATH
cd $HOME
input="${IN_PATH:-$INPUT_PATH_DEFAULT}"
output="$input.csv"

echo "resource_name,def_priority,def_name,def_desc,def_freq,def_count,def_range,condition_thresholdMetric,condition_thresholdCompare,condition_thresholdValue,def_enabled,def_active,escalation_name,action_value" > $output

let itemsCount=$(xmllint --xpath 'count(//AlertDefinitionsResponse/AlertDefinition)' $input)

for (( i=1; i <= $itemsCount; i++)); do
	alertdef="$(xmllint --xpath '//AlertDefinitionsResponse/AlertDefinition['$i']' $input)"
	def_name="$(xmllint --xpath 'AlertDefinition/@name' - <<<"$alertdef" | awk -F'name=\"' '{print $2}' | sed -e 's/"$')"
		def_desc="$(xmllint --xpath 'AlertDefinition/@description' - <<<"$alertdef" | awk -F'description=\"' '{print $2}' | sed -e 's/"$')"
		def_priority="$(xmllint --xpath 'AlertDefinition/@priority' - <<<"$alertdef" | awk -F'priority=\"' '{print $2}' | sed -e 's/"$')"
		def_enabled="$(xmllint --xpath 'AlertDefinition/@enabled' - <<<"$alertdef" | awk -F'enabled=\"' '{print $2}' | sed -e 's/"$')"
		def_active="$(xmllint --xpath 'AlertDefinition/@active' - <<<"$alertdef" | awk -F'active=\"' '{print $2}' | sed -e 's/"$')"
		def_freq="$(xmllint --xpath 'AlertDefinition/@frequency' - <<<"$alertdef" | awk -F'frequency=\"' '{print $2}' | sed -e 's/"$')"
		def_count="$(xmllint --xpath 'AlertDefinition/@count' - <<<"$alertdef" | awk -F'count=\"' '{print $2}' | sed -e 's/"$')"
		def_range="$(xmllint --xpath 'AlertDefinition/@range' - <<<"$alertdef" | awk -F'range=\"' '{print $2}' | sed -e 's/"$')"
	resource_name="$(xmllint --xpath 'AlertDefinition/Resource/@name' - <<<"$alertdef" | awk -F'name=\"' '{ print $2 }' | sed -e 's/"$')"
	escalation_name="$(xmllint --xpath 'AlertDefinition/Escalation/@name' - <<<"$alertdef"  | awk -F' name=\"' '{ print $2 }' | sed -e 's/"$')"
	condition_thresholdValue="$(xmllint --xpath 'AlertDefinition/AlertCondition/@thresholdValue' - <<<"$alertdef"  | awk -F' thresholdValue=\"' '{ print $2 }' | sed -e 's/"$')"
	condition_thresholdCompare="$(xmllint --xpath 'AlertDefinition/AlertCondition/@thresholdComparator' - <<<"$alertdef"  | awk -F' thresholdComparator=\"' '{ print $2 }' | sed -e 's/"$')"
	condition_thresholdMetric="$(xmllint --xpath 'AlertDefinition/AlertCondition/@thresholdMetric' - <<<"$alertdef"  | awk -F' thresholdMetric=\"' '{ print $2 }' | sed -e 's/"$')"
	action_value="$(xmllint --xpath 'AlertDefinition/AlertAction/AlertActionConfig['2']/@value' - <<<"$alertdef"  | awk -F' value=\"' '{ print $2 }' | sed -e 's/"$')"
	echo "$resource_name,$def_priority,$def_name,$def_desc,$def_freq,$def_count,$def_range,$condition_thresholdMetric,$condition_thresholdCompare,$condition_thresholdValue,$def_enabled,$def_active,$escalation_name,$action_value" >> $output
	echo "$i/$itemsCount Done"
done | tee $HOME/summary.out

echo "Output `pwd`/$output is successfully created"
