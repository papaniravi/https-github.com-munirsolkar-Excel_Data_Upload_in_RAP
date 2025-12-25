projection;
strict ( 2 );

define behavior for ZC_UPLOAD_DATA alias UploadData
{
  use create;
  use update;
  use delete;

  use action Edit;
  use action Activate;
  use action Discard;
  use action Resume;
  use action Prepare;

  use action uploadFromExcel;
}
