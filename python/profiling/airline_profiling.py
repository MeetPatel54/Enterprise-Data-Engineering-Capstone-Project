import pandas as pd
import os
from ydata_profiling import ProfileReport


# ============================================================
# 1. AUTOMATICALLY USE THE CURRENT PYTHON FILE'S FOLDER
# ============================================================

DATA_FOLDER = os.path.dirname(os.path.abspath(__file__))

REPORT_FOLDER = os.path.join(
    DATA_FOLDER,
    "profiling_reports"
)

os.makedirs(REPORT_FOLDER, exist_ok=True)


# ============================================================
# 2. FUNCTION TO LOAD CSV, EXCEL AND JSON
# ============================================================

def load_dataset(file_path):

    extension = os.path.splitext(file_path)[1].lower()

    if extension == ".csv":

        return pd.read_csv(file_path)

    elif extension == ".xlsx":

        return pd.read_excel(file_path)

    elif extension == ".json":

        return pd.read_json(file_path)

    else:

        raise ValueError(
            f"Unsupported file format: {extension}"
        )


# ============================================================
# 3. FIND ALL DATASETS
# ============================================================

supported_extensions = [
    ".csv",
    ".xlsx",
    ".json"
]

files = [
    f
    for f in os.listdir(DATA_FOLDER)
    if os.path.splitext(f)[1].lower()
    in supported_extensions
]


print("=" * 80)
print("AIRLINE DATA PROFILING")
print("=" * 80)

print("\nData folder:")
print(DATA_FOLDER)

print("\nDatasets found:", len(files))

print("\nFiles:")

for file in files:
    print(" -", file)


# ============================================================
# 4. PROFILING SUMMARY
# ============================================================

profiling_summary = []


# ============================================================
# 5. PROCESS EVERY DATASET
# ============================================================

for file in files:

    file_path = os.path.join(
        DATA_FOLDER,
        file
    )

    print("\n")
    print("=" * 80)
    print("Processing:", file)
    print("=" * 80)

    try:

        # ----------------------------------------------------
        # LOAD DATASET
        # ----------------------------------------------------

        df = load_dataset(file_path)

        print("Dataset loaded successfully.")

        # ----------------------------------------------------
        # BASIC INFORMATION
        # ----------------------------------------------------

        rows = df.shape[0]

        columns = df.shape[1]

        total_cells = rows * columns

        # ----------------------------------------------------
        # MISSING VALUES
        # ----------------------------------------------------

        missing_cells = df.isnull().sum().sum()

        if total_cells > 0:

            missing_percentage = (
                missing_cells /
                total_cells
            ) * 100

        else:

            missing_percentage = 0

        # ----------------------------------------------------
        # DUPLICATE ROWS
        # ----------------------------------------------------

        duplicate_rows = df.duplicated().sum()

        if rows > 0:

            duplicate_percentage = (
                duplicate_rows /
                rows
            ) * 100

        else:

            duplicate_percentage = 0

        # ----------------------------------------------------
        # DISPLAY INFORMATION
        # ----------------------------------------------------

        print("Rows:", rows)

        print("Columns:", columns)

        print("Missing cells:", missing_cells)

        print(
            "Missing percentage:",
            round(missing_percentage, 2),
            "%"
        )

        print("Duplicate rows:", duplicate_rows)

        print(
            "Duplicate percentage:",
            round(duplicate_percentage, 2),
            "%"
        )

        print("\nColumn names:")

        for column in df.columns:

            print("   ", column)

        # ====================================================
        # CREATE YDATA PROFILING REPORT
        # ====================================================

        print("\nCreating YData Profiling report...")

        profile = ProfileReport(
            df,
            title=f"Airline Data Profiling Report - {file}",
            explorative=True
        )

        # ----------------------------------------------------
        # REPORT FILE NAME
        # ----------------------------------------------------

        base_name = os.path.splitext(file)[0]

        report_file = os.path.join(
            REPORT_FOLDER,
            base_name + "_profiling_report.html"
        )

        # ----------------------------------------------------
        # SAVE REPORT
        # ----------------------------------------------------

        profile.to_file(report_file)

        print("\nProfiling report created:")

        print(report_file)

        # ====================================================
        # ADD DATA TO SUMMARY
        # ====================================================

        profiling_summary.append({

            "Dataset": file,

            "Rows": rows,

            "Columns": columns,

            "Total Cells": total_cells,

            "Missing Cells": missing_cells,

            "Missing %": round(
                missing_percentage,
                2
            ),

            "Duplicate Rows": duplicate_rows,

            "Duplicate %": round(
                duplicate_percentage,
                2
            )

        })

    except Exception as e:

        print("\nERROR while processing:", file)

        print("Error:", e)


# ============================================================
# 6. CREATE SUMMARY DATAFRAME
# ============================================================

summary_df = pd.DataFrame(
    profiling_summary
)


# ============================================================
# 7. SAVE SUMMARY AS EXCEL
# ============================================================

summary_file = os.path.join(
    DATA_FOLDER,
    "Airline_Data_Profiling_Summary.xlsx"
)


summary_df.to_excel(
    summary_file,
    index=False
)


# ============================================================
# 8. DISPLAY FINAL SUMMARY
# ============================================================

print("\n\n")
print("=" * 80)
print("PROFILING COMPLETED")
print("=" * 80)

print("\n")

if len(summary_df) > 0:

    print(
        summary_df.to_string(index=False)
    )

else:

    print(
        "No datasets were successfully processed."
    )


print("\n")

print("Profiling summary:")

print(summary_file)

print("\n")

print("Individual YData reports:")

print(REPORT_FOLDER)

print("\n")

print("=" * 80)
print("DONE")
print("=" * 80)