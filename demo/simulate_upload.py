#!/usr/bin/env python3
"""
Excel Data Upload RAP - Simulation Script

This script simulates the validation and processing logic
that would run in the SAP ABAP RAP application.
"""

import csv
import json
import uuid
from datetime import datetime, date
from typing import List, Dict, Tuple
from decimal import Decimal, InvalidOperation


class UploadRecord:
    """Represents a single upload record"""

    def __init__(self, data: Dict):
        self.upload_id = str(uuid.uuid4())
        self.document_number = data.get('Document Number', '').strip()
        self.document_date = data.get('Document Date', '').strip()
        self.customer_id = data.get('Customer ID', '').strip()
        self.customer_name = data.get('Customer Name', '').strip()
        self.amount = data.get('Amount', '').strip()
        self.currency = data.get('Currency', '').strip()
        self.status = 'P'  # P = Pending
        self.error_message = ''
        self.created_by = 'DEMO_USER'
        self.created_at = datetime.now().isoformat()

    def to_dict(self) -> Dict:
        """Convert to dictionary"""
        return {
            'UploadId': self.upload_id,
            'DocumentNumber': self.document_number,
            'DocumentDate': self.document_date,
            'CustomerId': self.customer_id,
            'CustomerName': self.customer_name,
            'Amount': self.amount,
            'Currency': self.currency,
            'Status': self.status,
            'ErrorMessage': self.error_message,
            'CreatedBy': self.created_by,
            'CreatedAt': self.created_at
        }


class ValidationEngine:
    """Validates upload records according to business rules"""

    @staticmethod
    def validate_document_number(record: UploadRecord) -> Tuple[bool, str]:
        """Validate document number"""
        if not record.document_number:
            return False, "Document number is required"
        if len(record.document_number) > 10:
            return False, "Document number too long (max 10 chars)"
        return True, ""

    @staticmethod
    def validate_document_date(record: UploadRecord) -> Tuple[bool, str]:
        """Validate document date"""
        if not record.document_date:
            return False, "Document date is mandatory"

        try:
            # Try to parse date
            doc_date = datetime.strptime(record.document_date, '%Y-%m-%d').date()

            # Check if date is in future
            if doc_date > date.today():
                return False, "Document date cannot be in the future"

            return True, ""
        except ValueError:
            return False, "Invalid date format (use YYYY-MM-DD)"

    @staticmethod
    def validate_customer_id(record: UploadRecord) -> Tuple[bool, str]:
        """Validate customer ID"""
        if not record.customer_id:
            return False, "Customer ID is mandatory"
        if len(record.customer_id) > 10:
            return False, "Customer ID too long (max 10 chars)"
        return True, ""

    @staticmethod
    def validate_amount(record: UploadRecord) -> Tuple[bool, str]:
        """Validate amount"""
        if not record.amount:
            return False, "Amount is required"

        try:
            # Remove commas and convert to decimal
            amount_str = record.amount.replace(',', '')
            amount_val = Decimal(amount_str)

            if amount_val <= 0:
                return False, "Amount must be greater than zero"

            return True, ""
        except (InvalidOperation, ValueError):
            return False, "Invalid amount format"

    @staticmethod
    def validate_currency(record: UploadRecord) -> Tuple[bool, str]:
        """Validate currency"""
        if not record.currency:
            return False, "Currency should be specified"
        if len(record.currency) < 3 or len(record.currency) > 5:
            return False, "Invalid currency code length"
        return True, ""

    @staticmethod
    def validate_record(record: UploadRecord) -> Tuple[bool, List[str]]:
        """Validate entire record"""
        errors = []

        # Run all validations
        validations = [
            ValidationEngine.validate_document_number,
            ValidationEngine.validate_document_date,
            ValidationEngine.validate_customer_id,
            ValidationEngine.validate_amount,
            ValidationEngine.validate_currency
        ]

        for validation_func in validations:
            is_valid, error_msg = validation_func(record)
            if not is_valid:
                errors.append(error_msg)

        if errors:
            record.status = 'E'  # E = Error
            record.error_message = '; '.join(errors)
            return False, errors
        else:
            record.status = 'S'  # S = Success
            record.error_message = ''
            return True, []


class ExcelUploadProcessor:
    """Main processor for Excel uploads"""

    def __init__(self):
        self.validator = ValidationEngine()

    def process_csv_file(self, file_path: str) -> Dict:
        """Process CSV file (simulating Excel upload)"""
        print(f"\n{'='*70}")
        print(f"📊 Processing file: {file_path}")
        print(f"{'='*70}\n")

        records = []
        errors = []
        success_count = 0
        error_count = 0

        # Read CSV file
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                row_num = 1  # Header is row 0

                for row in reader:
                    row_num += 1

                    # Create record
                    record = UploadRecord(row)

                    # Validate record
                    is_valid, validation_errors = self.validator.validate_record(record)

                    # Track results
                    if is_valid:
                        success_count += 1
                        print(f"✅ Row {row_num}: {record.document_number} - Success")
                    else:
                        error_count += 1
                        print(f"❌ Row {row_num}: {record.document_number or '(missing)'} - FAILED")
                        for error in validation_errors:
                            print(f"   → {error}")

                    records.append(record.to_dict())

        except FileNotFoundError:
            print(f"❌ Error: File not found: {file_path}")
            return None
        except Exception as e:
            print(f"❌ Error processing file: {str(e)}")
            return None

        # Print summary
        print(f"\n{'-'*70}")
        print(f"📈 Upload Summary")
        print(f"{'-'*70}")
        print(f"Total Records:    {success_count + error_count}")
        print(f"✅ Successful:     {success_count}")
        print(f"❌ Failed:         {error_count}")
        print(f"{'='*70}\n")

        return {
            'totalRecords': success_count + error_count,
            'successCount': success_count,
            'errorCount': error_count,
            'records': records
        }

    def save_results(self, results: Dict, output_file: str):
        """Save processing results to JSON"""
        if results:
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(results, f, indent=2)
            print(f"💾 Results saved to: {output_file}\n")


def main():
    """Main demonstration function"""
    print("\n" + "="*70)
    print(" 🚀 SAP RAP Excel Upload - Simulation Demo")
    print("="*70)
    print("\nThis script simulates the validation logic from the ABAP RAP app.")
    print("In a real SAP system, this would run in ABAP on the application server.\n")

    processor = ExcelUploadProcessor()

    # Process valid sample file
    print("\n📋 Test 1: Processing VALID sample data...")
    print("-" * 70)
    results1 = processor.process_csv_file('demo/data/sample_upload_template.csv')
    if results1:
        processor.save_results(results1, 'demo/data/results_valid.json')

    # Process file with errors
    print("\n📋 Test 2: Processing sample data WITH ERRORS...")
    print("-" * 70)
    results2 = processor.process_csv_file('demo/data/sample_with_errors.csv')
    if results2:
        processor.save_results(results2, 'demo/data/results_with_errors.json')

    print("\n✨ Demo completed successfully!")
    print("\n💡 In a real SAP deployment:")
    print("   - This logic runs in ABAP on the SAP application server")
    print("   - Data is stored in SAP HANA database tables")
    print("   - UI is served via SAP Fiori Elements")
    print("   - Service is exposed as OData V4")
    print("\n📖 See INSTALLATION.md for deployment instructions\n")


if __name__ == '__main__':
    main()
