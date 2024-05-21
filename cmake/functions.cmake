
function(verilate TOP TB)
	get_filename_component(FILE_NAME_WE ${TOP} NAME_WE)
	get_filename_component(FILE_NAME ${TOP} NAME)
	add_custom_target("V${FILE_NAME_WE}" ALL
		DEPENDS "V${FILE_NAME_WE}.h"
			"${TOP}"
	)

	# # Add rust_example as a CMake target
	add_custom_command(
		OUTPUT "V${FILE_NAME_WE}.h"
		COMMENT "Verilating ${FILE_NAME}"
		COMMAND verilator -Wall --trace --cc ${TOP} --Mdir . --exe ${TB} -I${CMAKE_SOURCE_DIR}/build/design -I${CMAKE_SOURCE_DIR}/design --build > /dev/null
		DEPENDS 
			${TOP} 
			${TB}
	)

	install(
		FILES
			"${CMAKE_CURRENT_BINARY_DIR}/V${FILE_NAME_WE}"
		DESTINATION
			"${CMAKE_INSTALL_PREFIX}"
	)
endfunction()