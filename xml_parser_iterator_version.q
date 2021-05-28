/ DataLoading.q
// load Kx fusion interface in q here
// load util function here

\d .dl
 
pd:.p.import[`pandas];
np:.p.import[`numpy];
arrow:.p.import[`pyarrow];
et:.p.import`xml.etree.ElementTree;

// ensure (unkeyed) table input
checkTabInput:{$[.Q.qt x;0!x;'`$"not a table"]};

// ****
// XML
// ****

// Helper functions
scanroot:{data:.p.q2py x[`:text]`;.dl.row[`:append][data];};

scannode:{[x] 
  // Prepare all column fields per row  
  arr2:x[@;] each til .dl.shapeStat[1]; 
  .dl.row:.p.eval"[]"; 
  // Get all values from current row, iterate all columns
  scanroot'[arr2];
  // prepare column-value pairs from current row
  iter_dict:.dl.cols!.dl.row`;  
  // Assign current row data into rows
  .dl.rows[`:append;iter_dict];  
  iter_dict:();};
  
// Read XML to kdb+ table
xml2tab:{[dir;df_cols] xtree:et[`:parse;dir];
  .dl.cols:df_cols; xroot:xtree[`:getroot][::];
  .dl.rows:.p.eval"[]"; 
  // Get shapes and dimensions of XML file
  .dl.shapeStat:np[`:array][xroot][`:shape]`;
  // Prepare all rows per XML file from root
  arr1:xroot[@;] each til .dl.shapeStat[0];  
  scannode'[arr1];
  .ml.df2tab pd[`:DataFrame;.dl.rows;`columns pykw df_cols]};