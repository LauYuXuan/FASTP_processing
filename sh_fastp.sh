#!/bin/bash

# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <FASTQ_DIR> <OUTPUT_DIR>"
    exit 1
fi

# Assign the first argument to FASTQ_DIR
FASTQ_DIR="$1"

# Assign the second argument to OUTPUT_DIR
OUTPUT_DIR="$2"

# Navigate to the raw FASTQ files directory
cd "${FASTQ_DIR}" || { echo "Error: Cannot enter directory ${FASTQ_DIR}"; exit 1; }

# Loop through each SRR directory and process with fastp
for srr_dir in SRR*/; do
    echo "Processing directory: ${srr_dir}"

    # Use basename to strip the trailing slash and get the directory name
    srr_prefix=$(basename "${srr_dir}")

    # Create a subdirectory for processed files for the current sample
    mkdir -p "${OUTPUT_DIR}/${srr_prefix}" || { echo "Failed to create directory ${OUTPUT_DIR}/${srr_prefix}"; continue; }

    # Assuming there's a single pair of files in each directory following the pattern *_{1,2}.fastq
    # Extract the sample name by listing the files and stripping the suffix
    sample_name=$(ls "${srr_dir}"*"_1.fastq" | head -n 1 | sed "s/_1.fastq//")

    # If the sample name couldn't be determined, continue to the next directory
    if [ -z "${sample_name}" ]; then
        echo "ERROR: No matching files for pattern *_1.fastq in directory ${srr_dir}"
        continue
    fi

    # Extract just the sample name without the path
    sample_name=$(basename "${sample_name}")

    # Check if the output files already exist
    if [ -f "${OUTPUT_DIR}/${srr_prefix}/${sample_name}_cleaned_1.fastq" ] && \
       [ -f "${OUTPUT_DIR}/${srr_prefix}/${sample_name}_cleaned_2.fastq" ]; then
        echo "Output files already exist for ${sample_name}. Skipping fastp processing."
        continue
    fi

    # Run fastp on the paired-end files
    if ! fastp -i "${srr_dir}${sample_name}_1.fastq" -I "${srr_dir}${sample_name}_2.fastq" \
          -o "${OUTPUT_DIR}/${srr_prefix}/${sample_name}_cleaned_1.fastq" \
          -O "${OUTPUT_DIR}/${srr_prefix}/${sample_name}_cleaned_2.fastq" \
          -h "${OUTPUT_DIR}/${srr_prefix}/fastp_report_${sample_name}.html" \
          -j "${OUTPUT_DIR}/${srr_prefix}/fastp_report_${sample_name}.json"
    then
        echo "fastp failed on ${srr_dir}"
        continue
    fi

    echo "Finished processing ${srr_dir}"
done

echo "All done!"
