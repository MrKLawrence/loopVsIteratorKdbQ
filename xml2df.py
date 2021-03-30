import pandas as pd
import xml.etree.ElementTree as et

def parse_xml_to_q(xml_file, df_cols): 
    xtree = et.parse(xml_file)
    xroot = xtree.getroot()
    rows = []
    iter_dict = {}
			
    for node in xroot: 
        res = []	
        for el in df_cols:
            if node is not None and node.find(el) is not None:
                res.append(node.find(el).text)
            else:
                res.append(None)

        count = 0
        for k in df_cols:
            iter_dict[k] = res[count]
            count = count + 1				 
        rows.append(iter_dict)
        iter_dict = {}

    out_df = pd.DataFrame(rows, columns=df_cols)
    return out_df

print(parse_xml_to_q("test.xml",['messageType','tradeID','buyOrderID','sellOrderID','buyClientID','sellClientID','time','date','sym','price','size']))
