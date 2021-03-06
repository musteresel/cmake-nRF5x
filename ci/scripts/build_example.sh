#!/bin/bash

source "${BASH_SOURCE%/*}/common/build_example.sh"

function print_help() {
    echo "
    Usage:
    --------------------------------------------------------------------------------

    [Mandatory]

        --example=<example>         Local example directory as present in the nRF SDK,
                                    e.g. peripheral/blinky 

        --sdk_version=<version>     nRF SDK version, e.g. 15.3.0

        --board=<board>             Board symbol, e.g. pca10040, pca10056

        --sd_variant=<variant>      SoftDevice variant, e.g. s132, s140

    [Optional]

        --toolchain=<toolchain>     Toolchain, e.g. gcc [default]

        --config_dir=<dir>          Configuration directory where configuration files
                                    (.ld files, sdk_config.h) are located. The directory
                                    tree must follow the structure of configuration directories
                                    found in the SDK, e.g. examples/peripheral/blinky.

        --build_dir=<dir>           Build directory where the build system files
                                    and build artifacts will be generated.

        --log_level=<log_level>     CMake log level. Will be passed as '--log-level' option
                                    when invoking CMake. Available log levels: TRACE, DEBUG,
                                    VERBOSE, STATUS, NOTICE, WARNING, ERROR.
        
        --clean                     Invoke build system 'Clean' command before commencing build.

    "
    exit 0
}

function check_option() {
    if [[ $# -lt 2 ]] || [[ -z $1 ]]; then
        echo "Missing mandatory option \"--$1\", use \"--help\""
        exit 1 
    fi
}

example=""
sdk_version=""
board=""
sd_variant=""
toolchain="gcc"
config_dir=""
log_level="STATUS"
flags=()

while getopts ":h-:" opt; do
    case $opt in
        -) {
            # Handle long options ("--option=<arg>")
            case $OPTARG in
                example=*)
                    example=${OPTARG#*=} ;;
                sdk_version=*)
                    sdk_version=${OPTARG#*=} ;;
                board=*)
                    board=${OPTARG#*=} ;;
                sd_variant=*)
                    sd_variant=${OPTARG#*=} ;;
                toolchain=*)
                    toolchain=${OPTARG#*=} ;;
                config_dir=*)
                    config_dir=${OPTARG#*=} ;;
                build_dir=*)
                    build_dir=${OPTARG#*=} ;;
                log_level=*) {
                    log_level=${OPTARG#*=} 
                    if [[ ! $log_level =~ $CMAKE_LOG_LEVEL_REGEXP ]]; then
                        echo "Invalid log level \"$log_level\" (available log levels: TRACE, DEBUG, VERBOSE, STATUS, NOTICE, WARNING, ERROR)"
                        exit 1
                    fi
                };;
                clean)
                    flags+=('clean') ;;
                help)
                    print_help ;;
                *) {
                    if [[ $OPTERR -eq 1 ]]; then
                        echo "Unknown option \"--$OPTARG\" or missing argument (use \"--option=<arg>\" syntax), use \"--help\""
                        exit 1
                    fi
                };;
            esac
        };;
        h) {
            print_help
        };;
        \?) {
            unknown_optind=$(($OPTIND - 1))
            unknown_opt=${!unknown_optind}
            echo "Uknown option \"$unknown_opt\""
            exit 1
        };;
    esac
done

# Check mandatory options
check_option "example" $example
check_option "sdk_version" $sdk_version
check_option "board" $board
check_option "sd_variant" $sd_variant

build_example "$example" "$sdk_version" "$board" "$sd_variant" "$toolchain" "$config_dir" "$build_dir" "$log_level" "${flags[*]}"
