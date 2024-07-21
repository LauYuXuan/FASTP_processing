
# FASTP Processing Script

This Bash script automates the processing of FASTQ files using the `fastp` tool. It's designed to handle multiple SRR (Sequence Read Run) directories, each containing paired-end FASTQ files.

## Features

- Processes multiple SRR directories in batch
- Handles paired-end FASTQ files
- Uses `fastp` for FASTQ file processing
- Creates separate output directories for each SRR
- Generates HTML and JSON reports for each processed sample
- Skips processing if output files already exist

## Prerequisites

- Bash shell
- `fastp` tool installed and accessible in the system PATH

## Usage

```bash
./script_name.sh <FASTQ_DIR> <OUTPUT_DIR>
<FASTQ_DIR>: Directory containing SRR subdirectories with raw FASTQ files
<OUTPUT_DIR>: Directory where processed files and reports will be saved
Directory Structure
Input directory (FASTQ_DIR) should have this structure:

FASTQ_DIR/
├── SRR1/
│   ├── sample1_1.fastq
│   └── sample1_2.fastq
├── SRR2/
│   ├── sample2_1.fastq
│   └── sample2_2.fastq
└── ...
Output directory (OUTPUT_DIR) will be structured as:

OUTPUT_DIR/
├── SRR1/
│   ├── sample1_cleaned_1.fastq
│   ├── sample1_cleaned_2.fastq
│   ├── fastp_report_sample1.html
│   └── fastp_report_sample1.json
├── SRR2/
│   ├── sample2_cleaned_1.fastq
│   ├── sample2_cleaned_2.fastq
│   ├── fastp_report_sample2.html
│   └── fastp_report_sample2.json
└── ...


The script navigates to the directory containing raw FASTQ files.
It loops through each SRR directory.
For each SRR:
It creates a corresponding output directory.
It identifies the sample name from the FASTQ file names.
If output files don't already exist, it runs fastp on the paired-end files.
It generates cleaned FASTQ files and fastp reports.
The script continues to the next SRR directory until all are processed.
Error Handling
The script checks for the correct number of arguments.
It verifies if it can enter the FASTQ directory.
It checks if output files already exist to avoid unnecessary processing.
It reports any errors during the fastp processing.
Note
Ensure that your input FASTQ files follow the naming convention *_1.fastq and *_2.fastq for paired-end reads.

