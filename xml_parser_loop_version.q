/ DataLoading.q
// load Kx fusion interface in q here
// load util function here

\d .dl
 
pd:.p.import[`pandas];
np:.p.import[`numpy];
arrow:.p.import[`pyarrow];
et:.p.import`xml.etree.ElementTree;
  
// Read XML to kdb+ tab
xml2tab:{[dir;df_cols]
  xtree:et[`:parse;dir];
  xroot:xtree[`:getroot][::];
  rows:.p.eval"[]";
  // Get shapes and dimensions of XML file
  shapeStat:np[`:array][xroot][`:shape]`; 
  i:0;
  // Prepare all rows per XML file from root
  arr1:xroot[@;] each til shapeStat[0]; 
  while[i<shapeStat[0]; 
      // Prepare all column fields per row
      arr2:arr1[i][@;] each til shapeStat[1]; 
	  row:.p.eval"[]";
	  j:0;
	  // Get all values from current row
	  while[j<shapeStat[1];
	      row[`:append][.p.q2py arr2[j][`:text]`];
		  j:j+1
      ]; 
      // prepare column-value pairs from current row
	  iter_dict:df_cols!row`; 
	  // Assign current row data into rows
	  rows[`:append;iter_dict]; 
	  iter_dict:();
	  i:i+1
  ];
  .ml.df2tab pd[`:DataFrame;rows;`columns pykw df_cols]
  };