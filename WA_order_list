#!/usr/local/bin/python3.7


import xml.etree.ElementTree as et
import re
import csv
import collections

csvData = []
xtree = et.parse("/Users/prashantsingh/Downloads/new.xml")

root = xtree.getroot()
tag_prefix = '{http://www.mediawiki.org/xml/export-0.10/}'


# Finding the Page content for given page containing text as well as links.
for x in root:

   if x[0].tag == tag_prefix+'title' and x.tag == tag_prefix+'page':
      for y in x:
            if y.tag == tag_prefix+'revision':
                for z in y:
                    if z.tag == tag_prefix+'text':
                       Page=z.text

# Finding the ordered linked list for all links in Specific page
      pattern = '\[\[[\w,\W]*?\]\]'
      result = re.findall(pattern, Page)
      #print(len(result))

# removing all category links and File links
      updated_result = [item for item in result if not item.startswith('[[Category:') and not item.startswith('[[File:')]
      #print(len(updated_result))

# Creating a final ordered list with all page links after removing labels like [[<link>|<label>]] as well as removing '[' and ']'
      finalresult = []

      for item in updated_result:
         if '|' in item:
           finalresult.append(item.split('|')[0].split('[')[2])
         else:
           finalresult.append(item.split('[')[2].split(']')[0])

# Creating a csv in format as Page_source, Page_Referred, position of Referred page in Source page
# Also, Capitalizing the Page_Referred because it appears in same format in pagelinks table
      unique_list=list(collections.OrderedDict.fromkeys(finalresult))
      tmp_data=[]
      i = 0
      for i in range(len(unique_list)):
           tmp_data.append([x[0].text, unique_list[i].title().replace(" ","_").encode('utf8'), i+1])

      #print(tmp_data)
      csvData.extend(tmp_data)

print(csvData)

with open('/Users/prashantsingh/Downloads/link_order.csv', 'w') as csvFile:
    writer = csv.writer(csvFile)
    writer.writerows(csvData)

csvFile.close()
