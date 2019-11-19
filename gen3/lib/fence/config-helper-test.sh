#!/bin/bash

assertFilesSame() {
  local testName
  local outputFilePath
  local expectedResultPath
  testName="$1"
  outputFilePath="$2"
  expectedResultPath="$3"

  if [[ ! -f $outputFilePath ]]; then
    echo "Error: no output result"
    exit 1
  fi
  cmpRes=`diff $outputFilePath $expectedResultPath -b -B`
  cmpStatus=$?
  if [[ $cmpStatus -eq 0 ]];then
    echo "Pass: \"$testName\""
  else
    echo "Fail: \"$testName\""
    echo "$cmpRes"
    exit 1
  fi
}

tmpSecretJSONFile="./secret.json"
tmpPubYamlFile="./pub.yaml"
secretTemplateJSON="../testData/gen3_fence/simple-secret-template.json"
configYaml="../testData/gen3_fence/test-simple-config.yaml"
configTemplateYaml="../testData/gen3_fence/test-simple-config-default.yaml"

python ./config-helper.py -e $secretTemplateJSON -c $configYaml > $tmpSecretJSONFile
assertFilesSame "extract secrets to a JSON file" $tmpSecretJSONFile ../testData/gen3_fence/expectedExtractedSecrets.json

python ./config-helper.py -d $secretTemplateJSON -c $configYaml > $tmpPubYamlFile
assertFilesSame "delete secrets from a yaml file" $tmpPubYamlFile ../testData/gen3_fence/expectedPublicConfigs.yaml

python ./config-helper.py -r $tmpSecretJSONFile -c ../testData/gen3_fence/test-simple-config-default.yaml > tmp1.yaml
python ./config-helper.py -r $tmpPubYamlFile -c tmp1.yaml > tmp.yaml
assertFilesSame "inject back secrets and pub configs to a yaml file" tmp.yaml $configYaml

rm $tmpPubYamlFile $tmpSecretJSONFile $tmpYamlFile
