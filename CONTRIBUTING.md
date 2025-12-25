# Contributing to Excel Data Upload in RAP

Thank you for your interest in contributing to this SAP RAP project! This document provides guidelines and instructions for contributing.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Process](#development-process)
4. [Coding Standards](#coding-standards)
5. [Testing Guidelines](#testing-guidelines)
6. [Submitting Changes](#submitting-changes)
7. [Reporting Issues](#reporting-issues)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors. Please:
- Be respectful and constructive
- Accept constructive criticism gracefully
- Focus on what's best for the project
- Show empathy towards other contributors

## Getting Started

### Prerequisites

Before contributing, ensure you have:
- SAP BTP ABAP Environment or SAP S/4HANA 2020+
- ABAP Development Tools (ADT) in Eclipse
- Git knowledge
- Understanding of SAP RAP concepts
- Access to a development system

### Setting Up Development Environment

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/Excel_Data_Upload_in_RAP.git
   ```

2. **Import into ADT**
   - Create a new ABAP package
   - Import all objects from the repository
   - Activate all objects

3. **Verify Setup**
   - Run syntax checks
   - Activate service binding
   - Test in preview mode

## Development Process

### Branching Strategy

We follow a simple branching model:

- `main` - Production-ready code
- `develop` - Integration branch for features
- `feature/*` - New features or enhancements
- `bugfix/*` - Bug fixes
- `hotfix/*` - Urgent production fixes

### Creating a Feature Branch

```bash
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name
```

### Workflow

1. **Create an Issue**
   - Describe the feature or bug
   - Get feedback before starting work

2. **Develop**
   - Write code following our standards
   - Test thoroughly
   - Document your changes

3. **Commit**
   - Write clear commit messages
   - Reference issue numbers

4. **Push and Create Pull Request**
   - Push to your branch
   - Create PR to `develop` branch
   - Fill out PR template

## Coding Standards

### ABAP Naming Conventions

Follow SAP naming conventions:

- **Database Tables**: `ZTABLE_*` or `YTABLE_*`
- **CDS Views**: `ZI_*` (Interface), `ZC_*` (Consumption)
- **Classes**: `ZCL_*` or `YCL_*`
- **Behavior Pools**: `ZBP_*` or `YBP_*`
- **Service Definitions**: `ZSD_*` or `YSD_*`
- **Service Bindings**: `ZSB_*` or `YSB_*`

### Code Style

#### Variables
```abap
" Good
DATA(lv_customer_id) = 'CUST001'.
DATA lt_upload_data TYPE TABLE OF ty_upload_data.

" Avoid
DATA x TYPE string.
DATA temp.
```

#### Methods
```abap
" Good - Clear, descriptive names
METHOD validate_customer_data.
METHOD process_excel_file.

" Avoid - Unclear names
METHOD do_validation.
METHOD process.
```

#### Comments
```abap
" Good - Explain WHY, not WHAT
" Convert Excel date format to SAP date format
" because Excel stores dates as serial numbers
rv_date = convert_excel_date( iv_excel_value ).

" Avoid - Obvious comments
" Assign value
lv_value = 1.
```

### ABAP Best Practices

1. **Use Modern ABAP**
   - Prefer inline declarations
   - Use constructor expressions
   - Leverage ABAP 7.40+ syntax

2. **Error Handling**
   - Always use TRY-CATCH blocks
   - Provide meaningful error messages
   - Log errors appropriately

3. **Performance**
   - Avoid SELECT in loops
   - Use bulk operations
   - Optimize database queries

4. **Clean Code**
   - Keep methods small and focused
   - One responsibility per method
   - DRY (Don't Repeat Yourself)

### CDS View Guidelines

```abap
" Good - Clear annotations and associations
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Upload Data Interface View'
define root view entity ZI_UPLOAD_DATA
  as select from ztable_upload_data
{
  key upload_id as UploadId,
      @Semantics.amount.currencyCode: 'Currency'
      amount as Amount,
      @Semantics.currencyCode: true
      currency as Currency
}
```

### UI Annotations

```abap
" Good - Organized and complete
@UI: {
  lineItem: [{ position: 10, importance: #HIGH }],
  fieldGroup: [{ qualifier: 'BasicData', position: 10 }],
  selectionField: [{ position: 10 }]
}
DocumentNumber;
```

## Testing Guidelines

### Unit Testing

Create unit tests for:
- Behavior implementations
- Utility classes
- Validation logic
- Data conversion methods

Example:
```abap
CLASS ltc_excel_upload DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_validate_positive_amount FOR TESTING,
      test_validate_future_date FOR TESTING,
      test_convert_date_format FOR TESTING.

ENDCLASS.
```

### Integration Testing

Test:
- Complete upload workflow
- Service operations (CRUD)
- Draft handling
- Error scenarios

### Manual Testing Checklist

Before submitting:
- [ ] All objects activate without errors
- [ ] Service binding publishes successfully
- [ ] Preview shows correct data
- [ ] CRUD operations work
- [ ] Validations trigger correctly
- [ ] Error messages are clear
- [ ] UI renders properly

## Submitting Changes

### Pull Request Process

1. **Update Documentation**
   - Update README if needed
   - Add to CHANGELOG.md
   - Update inline comments

2. **Self Review**
   - Check code quality
   - Run all tests
   - Verify no debug/test code

3. **Create Pull Request**
   - Use descriptive title
   - Reference related issues
   - Describe changes clearly
   - Add screenshots if UI changes

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests passed
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project standards
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] No console.logs or debug code
- [ ] All objects activated

## Screenshots (if applicable)
[Add screenshots here]

## Related Issues
Fixes #123
```

### Commit Message Format

Follow conventional commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting changes
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```
feat(upload): add CSV file support

Implemented CSV file parsing alongside Excel upload.
Added new utility methods for CSV processing.

Closes #45

fix(validation): correct date validation logic

Future date validation was incorrectly allowing dates
one day in the future due to timezone issue.

Fixes #67
```

## Reporting Issues

### Bug Reports

Use this template:

```markdown
**Describe the bug**
Clear description of the bug

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What should happen

**Screenshots**
If applicable

**Environment:**
 - SAP Version: [e.g., S/4HANA 2022]
 - ABAP Version: [e.g., 7.56]
 - Browser: [if UI issue]

**Additional context**
Any other relevant information
```

### Feature Requests

```markdown
**Is your feature request related to a problem?**
Description of the problem

**Describe the solution you'd like**
Clear description of desired feature

**Describe alternatives considered**
Alternative approaches

**Additional context**
Mockups, examples, etc.
```

## Areas for Contribution

We welcome contributions in:

### High Priority
- Enhanced Excel parsing logic
- Additional validations
- Performance optimizations
- Bug fixes

### Medium Priority
- UI improvements
- Additional field support
- Error handling enhancements
- Documentation improvements

### Low Priority
- Code refactoring
- Test coverage
- Examples and tutorials

## Questions?

- Check existing issues and documentation
- Ask in discussions section
- Contact maintainers

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation

Thank you for contributing to make this project better!

---

Last Updated: 2024-12-25
