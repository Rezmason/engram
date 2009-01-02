#!/bin/bash

# TextMate Project variables. Add to the tmproject vars to use the default compile scripts.
# TM_FLEX_FILE_SPECS 	src/FlexCheck.mxml
# TM_FLEX_OUTPUT 		deploy/FlexCheck.swf

echo "<h2>FlexCheck Custom Compile</h2>";
echo "<code> Started @ `date "+%H:%M:%S"`</code><br />";

"$TM_FLEX_PATH/bin/mxmlc" \
	-sp+="$TM_AS3_LIB_PATH" \
	-file-specs="src/FlexCheck.as" \
	-o="deploy/FlexCheck.swf" 2>&1 | "$TM_BUNDLE_SUPPORT/bin/parse_mxmlc_out.rb";

if [ "$?" == "0" ]
	then
	open "deploy/index.html";
fi
