@Metadata.layer: #CORE
@UI: {
  headerInfo: {
    typeName: 'Upload Record',
    typeNamePlural: 'Upload Records',
    title: {
      type: #STANDARD,
      label: 'Upload Data',
      value: 'DocumentNumber'
    }
  },
  presentationVariant: [{
    sortOrder: [{
      by: 'DocumentDate',
      direction: #DESC
    }],
    visualizations: [{
      type: #AS_LINEITEM
    }]
  }]
}
annotate view ZC_UPLOAD_DATA with
{
  @UI.facet: [
    {
      id: 'GeneralInfo',
      type: #COLLECTION,
      label: 'General Information',
      position: 10
    },
    {
      id: 'BasicData',
      type: #FIELDGROUP_REFERENCE,
      label: 'Document Details',
      targetQualifier: 'BasicData',
      parentId: 'GeneralInfo',
      position: 10
    },
    {
      id: 'CustomerData',
      type: #FIELDGROUP_REFERENCE,
      label: 'Customer Information',
      targetQualifier: 'CustomerData',
      parentId: 'GeneralInfo',
      position: 20
    },
    {
      id: 'AmountData',
      type: #FIELDGROUP_REFERENCE,
      label: 'Amount Details',
      targetQualifier: 'AmountData',
      parentId: 'GeneralInfo',
      position: 30
    },
    {
      id: 'AdminData',
      type: #FIELDGROUP_REFERENCE,
      label: 'Administrative Data',
      targetQualifier: 'AdminData',
      parentId: 'GeneralInfo',
      position: 40
    }
  ]

  @UI.hidden: true
  UploadId;

  @UI: {
    lineItem: [{ position: 10, importance: #HIGH }],
    fieldGroup: [{ qualifier: 'BasicData', position: 10 }],
    selectionField: [{ position: 10 }]
  }
  DocumentNumber;

  @UI: {
    lineItem: [{ position: 20, importance: #HIGH }],
    fieldGroup: [{ qualifier: 'BasicData', position: 20 }],
    selectionField: [{ position: 20 }]
  }
  DocumentDate;

  @UI: {
    lineItem: [{ position: 30, importance: #HIGH }],
    fieldGroup: [{ qualifier: 'CustomerData', position: 10 }],
    selectionField: [{ position: 30 }]
  }
  CustomerId;

  @UI: {
    lineItem: [{ position: 40, importance: #HIGH }],
    fieldGroup: [{ qualifier: 'CustomerData', position: 20 }]
  }
  CustomerName;

  @UI: {
    lineItem: [{ position: 50, importance: #HIGH }],
    fieldGroup: [{ qualifier: 'AmountData', position: 10 }]
  }
  Amount;

  @UI: {
    lineItem: [{ position: 60, importance: #MEDIUM }],
    fieldGroup: [{ qualifier: 'AmountData', position: 20 }]
  }
  Currency;

  @UI: {
    lineItem: [{ position: 70, importance: #HIGH, criticality: 'Status' }],
    fieldGroup: [{ qualifier: 'BasicData', position: 30 }],
    selectionField: [{ position: 40 }]
  }
  Status;

  @UI: {
    lineItem: [{ position: 80, importance: #MEDIUM }],
    fieldGroup: [{ qualifier: 'BasicData', position: 40 }]
  }
  ErrorMessage;

  @UI.fieldGroup: [{ qualifier: 'AdminData', position: 10 }]
  CreatedBy;

  @UI.fieldGroup: [{ qualifier: 'AdminData', position: 20 }]
  CreatedAt;

  @UI.fieldGroup: [{ qualifier: 'AdminData', position: 30 }]
  LastChangedBy;

  @UI.fieldGroup: [{ qualifier: 'AdminData', position: 40 }]
  LastChangedAt;

  @UI.hidden: true
  LocalLastChangedAt;
}
