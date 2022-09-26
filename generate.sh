#!/bin/bash

__src_dir="./"
__dst_dir="${__src_dir}"
__proto_file_addresses=(
    'https://raw.githubusercontent.com/esphome/esphome/dev/esphome/components/api/api.proto'
    'https://raw.githubusercontent.com/esphome/esphome/dev/esphome/components/api/api_options.proto'
)

rm *.proto

for __url in "${__proto_file_addresses[@]}"; do
    wget -q "${__url}"
done

find . | grep -E '\.diff$' | while read -r __patch_file; do
    __proto_file="${__patch_file}"
    patch "${__proto_file/.diff}.proto" "${__patch_file}"
done

protoc -I="${__src_dir}" --go_out="${__dst_dir}" *.proto

go mod tidy

exit
