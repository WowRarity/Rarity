RELEVANT_LUA_FILES_TO_FORMAT=$(find . -type f -name "*.lua" -print -o -path "*/Libs" -prune)
lua-format -i -v $RELEVANT_LUA_FILES_TO_FORMAT