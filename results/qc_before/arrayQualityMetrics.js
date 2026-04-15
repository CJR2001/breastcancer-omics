// (C) Wolfgang Huber 2010-2011

// Script parameters - these are set up by R in the function 'writeReport' when copying the 
//   template for this script from arrayQualityMetrics/inst/scripts into the report.

var highlightInitial = [ false, true, false, false, false, false, true, true, true, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, true, false, true, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, false, false, false ];
var arrayMetadata    = [ [ "1", "GSM7294844_Sample001.CEL.gz", "1", "01/01/21 00:00:00" ], [ "2", "GSM7294845_Sample002.CEL.gz", "2", "01/01/21 00:00:00" ], [ "3", "GSM7294846_Sample003.CEL.gz", "3", "01/01/21 00:00:00" ], [ "4", "GSM7294847_Sample004.CEL.gz", "4", "01/01/21 00:00:00" ], [ "5", "GSM7294848_Sample005.CEL.gz", "5", "01/01/21 00:00:00" ], [ "6", "GSM7294849_Sample006.CEL.gz", "6", "01/01/21 00:00:00" ], [ "7", "GSM7294850_Sample007.CEL.gz", "7", "01/01/21 00:00:00" ], [ "8", "GSM7294851_Sample008.CEL.gz", "8", "01/01/21 00:00:00" ], [ "9", "GSM7294852_Sample009.CEL.gz", "9", "01/01/21 00:00:00" ], [ "10", "GSM7294853_Sample010.CEL.gz", "10", "01/01/21 00:00:00" ], [ "11", "GSM7294854_Sample011.CEL.gz", "11", "01/01/21 00:00:00" ], [ "12", "GSM7294855_Sample012.CEL.gz", "12", "01/01/21 00:00:00" ], [ "13", "GSM7294856_Sample013.CEL.gz", "13", "01/01/21 00:00:00" ], [ "14", "GSM7294857_Sample014.CEL.gz", "14", "01/01/21 00:00:00" ], [ "15", "GSM7294858_Sample015.CEL.gz", "15", "01/01/21 00:00:00" ], [ "16", "GSM7294859_Sample016.CEL.gz", "16", "01/01/21 00:00:00" ], [ "17", "GSM7294860_Sample017.CEL.gz", "17", "01/01/21 00:00:00" ], [ "18", "GSM7294861_Sample018.CEL.gz", "18", "01/01/21 00:00:00" ], [ "19", "GSM7294862_Sample019.CEL.gz", "19", "01/01/21 00:00:00" ], [ "20", "GSM7294863_Sample020.CEL.gz", "20", "01/01/21 00:00:00" ], [ "21", "GSM7294864_Sample021.CEL.gz", "21", "01/01/21 00:00:00" ], [ "22", "GSM7294865_Sample022.CEL.gz", "22", "01/01/21 00:00:00" ], [ "23", "GSM7294866_Sample023.CEL.gz", "23", "01/01/21 00:00:00" ], [ "24", "GSM7294867_Sample024.CEL.gz", "24", "01/01/21 00:00:00" ], [ "25", "GSM7294868_Sample025.CEL.gz", "25", "01/01/21 00:00:00" ], [ "26", "GSM7294869_Sample026.CEL.gz", "26", "01/01/21 00:00:00" ], [ "27", "GSM7294870_Sample027.CEL.gz", "27", "01/01/21 00:00:00" ], [ "28", "GSM7294871_Sample028.CEL.gz", "28", "01/01/21 00:00:00" ], [ "29", "GSM7294872_Sample029.CEL.gz", "29", "01/01/21 00:00:00" ], [ "30", "GSM7294873_Sample030.CEL.gz", "30", "01/01/21 00:00:00" ], [ "31", "GSM7294874_Sample031.CEL.gz", "31", "01/01/21 00:00:00" ], [ "32", "GSM7294875_Sample032.CEL.gz", "32", "01/01/21 00:00:00" ], [ "33", "GSM7294876_Sample033.CEL.gz", "33", "01/01/21 00:00:00" ], [ "34", "GSM7294877_Sample034.CEL.gz", "34", "01/01/21 00:00:00" ], [ "35", "GSM7294878_Sample035.CEL.gz", "35", "01/01/21 00:00:00" ], [ "36", "GSM7294879_Sample036.CEL.gz", "36", "01/01/21 00:00:00" ], [ "37", "GSM7294880_Sample037.CEL.gz", "37", "01/01/21 00:00:00" ], [ "38", "GSM7294881_Sample038.CEL.gz", "38", "01/01/21 00:00:00" ], [ "39", "GSM7294882_Sample039.CEL.gz", "39", "01/01/21 00:00:00" ], [ "40", "GSM7294883_Sample040.CEL.gz", "40", "01/01/21 00:00:00" ], [ "41", "GSM7294884_Sample041.CEL.gz", "41", "01/01/21 00:00:00" ], [ "42", "GSM7294885_Sample042.CEL.gz", "42", "01/01/21 00:00:00" ], [ "43", "GSM7294886_Sample043.CEL.gz", "43", "01/01/21 00:00:00" ], [ "44", "GSM7294887_Sample044.CEL.gz", "44", "01/01/21 00:00:00" ], [ "45", "GSM7294888_Sample045.CEL.gz", "45", "01/01/21 00:00:00" ], [ "46", "GSM7294889_Sample046.CEL.gz", "46", "01/01/21 00:00:00" ], [ "47", "GSM7294890_Sample047.CEL.gz", "47", "01/01/21 00:00:00" ], [ "48", "GSM7294891_Sample048.CEL.gz", "48", "01/01/21 00:00:00" ], [ "49", "GSM7294892_Sample049.CEL.gz", "49", "01/01/21 00:00:00" ], [ "50", "GSM7294893_Sample050.CEL.gz", "50", "01/01/21 00:00:00" ], [ "51", "GSM7294894_Sample051.CEL.gz", "51", "01/01/21 00:00:00" ], [ "52", "GSM7294895_Sample052.CEL.gz", "52", "01/01/21 00:00:00" ], [ "53", "GSM7294896_Sample053.CEL.gz", "53", "01/01/21 00:00:00" ], [ "54", "GSM7294897_Sample054.CEL.gz", "54", "01/01/21 00:00:00" ], [ "55", "GSM7294898_Sample055.CEL.gz", "55", "01/01/21 00:00:00" ], [ "56", "GSM7294899_Sample056.CEL.gz", "56", "01/01/21 00:00:00" ], [ "57", "GSM7294900_Sample057.CEL.gz", "57", "01/01/21 00:00:00" ], [ "58", "GSM7294901_Sample058.CEL.gz", "58", "01/01/21 00:00:00" ], [ "59", "GSM7294902_Sample059.CEL.gz", "59", "01/01/21 00:00:00" ], [ "60", "GSM7294903_Sample060.CEL.gz", "60", "01/01/21 00:00:00" ], [ "61", "GSM7294904_Sample061.CEL.gz", "61", "01/01/21 00:00:00" ], [ "62", "GSM7294905_Sample062.CEL.gz", "62", "01/01/21 00:00:00" ], [ "63", "GSM7294906_Sample063.CEL.gz", "63", "01/01/21 00:00:00" ], [ "64", "GSM7294907_Sample064.CEL.gz", "64", "01/01/21 00:00:00" ], [ "65", "GSM7294908_Sample065.CEL.gz", "65", "01/01/21 00:00:00" ], [ "66", "GSM7294909_Sample066.CEL.gz", "66", "01/01/21 00:00:00" ], [ "67", "GSM7294910_Sample067.CEL.gz", "67", "01/01/21 00:00:00" ], [ "68", "GSM7294911_Sample068.CEL.gz", "68", "01/01/21 00:00:00" ], [ "69", "GSM7294912_Sample069.CEL.gz", "69", "01/01/21 00:00:00" ], [ "70", "GSM7294913_Sample070.CEL.gz", "70", "01/01/21 00:00:00" ], [ "71", "GSM7294914_Sample071.CEL.gz", "71", "01/01/21 00:00:00" ], [ "72", "GSM7294915_Sample072.CEL.gz", "72", "01/01/21 00:00:00" ], [ "73", "GSM7294916_Sample073.CEL.gz", "73", "01/01/21 00:00:00" ], [ "74", "GSM7294917_Sample074.CEL.gz", "74", "01/01/21 00:00:00" ], [ "75", "GSM7294918_Sample075.CEL.gz", "75", "01/01/21 00:00:00" ], [ "76", "GSM7294919_Sample076.CEL.gz", "76", "01/01/21 00:00:00" ], [ "77", "GSM7294920_Sample077.CEL.gz", "77", "01/01/21 00:00:00" ], [ "78", "GSM7294921_Sample078.CEL.gz", "78", "01/01/21 00:00:00" ], [ "79", "GSM7294922_Sample079.CEL.gz", "79", "01/01/21 00:00:00" ], [ "80", "GSM7294923_Sample080.CEL.gz", "80", "01/01/21 00:00:00" ], [ "81", "GSM7294924_Sample081.CEL.gz", "81", "01/01/21 00:00:00" ], [ "82", "GSM7294925_Sample082.CEL.gz", "82", "01/01/21 00:00:00" ], [ "83", "GSM7294926_Sample083.CEL.gz", "83", "01/01/21 00:00:00" ], [ "84", "GSM7294927_Sample084.CEL.gz", "84", "01/01/21 00:00:00" ], [ "85", "GSM7294928_Sample085.CEL.gz", "85", "01/01/21 00:00:00" ], [ "86", "GSM7294929_Sample086.CEL.gz", "86", "01/01/21 00:00:00" ], [ "87", "GSM7294930_Sample087.CEL.gz", "87", "01/01/21 00:00:00" ], [ "88", "GSM7294931_Sample088.CEL.gz", "88", "01/01/21 00:00:00" ], [ "89", "GSM7294932_Sample089.CEL.gz", "89", "01/01/21 00:00:00" ], [ "90", "GSM7294933_Sample090.CEL.gz", "90", "01/01/21 00:00:00" ], [ "91", "GSM7294934_Sample091.CEL.gz", "91", "01/01/21 00:00:00" ], [ "92", "GSM7294935_Sample092.CEL.gz", "92", "01/01/21 00:00:00" ], [ "93", "GSM7294936_Sample093.CEL.gz", "93", "01/01/21 00:00:00" ], [ "94", "GSM7294937_Sample094.CEL.gz", "94", "01/01/21 00:00:00" ], [ "95", "GSM7294938_Sample095.CEL.gz", "95", "01/01/21 00:00:00" ], [ "96", "GSM7294939_Sample096.CEL.gz", "96", "01/01/21 00:00:00" ], [ "97", "GSM7294940_Sample097.CEL.gz", "97", "01/01/21 00:00:00" ], [ "98", "GSM7294941_Sample098.CEL.gz", "98", "01/01/21 00:00:00" ], [ "99", "GSM7294942_Sample099.CEL.gz", "99", "01/01/21 00:00:00" ], [ "100", "GSM7294943_Sample100.CEL.gz", "100", "01/01/21 00:00:00" ], [ "101", "GSM7294944_Sample101.CEL.gz", "101", "01/01/21 00:00:00" ], [ "102", "GSM7294945_Sample102.CEL.gz", "102", "01/01/21 00:00:00" ], [ "103", "GSM7294946_Sample103.CEL.gz", "103", "01/01/21 00:00:00" ], [ "104", "GSM7294947_Sample104.CEL.gz", "104", "01/01/21 00:00:00" ], [ "105", "GSM7294948_Sample105.CEL.gz", "105", "01/01/21 00:00:00" ], [ "106", "GSM7294949_Sample106.CEL.gz", "106", "01/01/21 00:00:00" ], [ "107", "GSM7294950_Sample107.CEL.gz", "107", "01/01/21 00:00:00" ], [ "108", "GSM7294951_Sample108.CEL.gz", "108", "01/01/21 00:00:00" ], [ "109", "GSM7294952_Sample109.CEL.gz", "109", "01/01/21 00:00:00" ] ];
var svgObjectNames   = [ "pca", "dens", "dig" ];

var cssText = ["stroke-width:1; stroke-opacity:0.4",
               "stroke-width:3; stroke-opacity:1" ];

// Global variables - these are set up below by 'reportinit'
var tables;             // array of all the associated ('tooltips') tables on the page
var checkboxes;         // the checkboxes
var ssrules;


function reportinit() 
{
 
    var a, i, status;

    /*--------find checkboxes and set them to start values------*/
    checkboxes = document.getElementsByName("ReportObjectCheckBoxes");
    if(checkboxes.length != highlightInitial.length)
	throw new Error("checkboxes.length=" + checkboxes.length + "  !=  "
                        + " highlightInitial.length="+ highlightInitial.length);
    
    /*--------find associated tables and cache their locations------*/
    tables = new Array(svgObjectNames.length);
    for(i=0; i<tables.length; i++) 
    {
        tables[i] = safeGetElementById("Tab:"+svgObjectNames[i]);
    }

    /*------- style sheet rules ---------*/
    var ss = document.styleSheets[0];
    ssrules = ss.cssRules ? ss.cssRules : ss.rules; 

    /*------- checkboxes[a] is (expected to be) of class HTMLInputElement ---*/
    for(a=0; a<checkboxes.length; a++)
    {
	checkboxes[a].checked = highlightInitial[a];
        status = checkboxes[a].checked; 
        setReportObj(a+1, status, false);
    }

}


function safeGetElementById(id)
{
    res = document.getElementById(id);
    if(res == null)
        throw new Error("Id '"+ id + "' not found.");
    return(res)
}

/*------------------------------------------------------------
   Highlighting of Report Objects 
 ---------------------------------------------------------------*/
function setReportObj(reportObjId, status, doTable)
{
    var i, j, plotObjIds, selector;

    if(doTable) {
	for(i=0; i<svgObjectNames.length; i++) {
	    showTipTable(i, reportObjId);
	} 
    }

    /* This works in Chrome 10, ssrules will be null; we use getElementsByClassName and loop over them */
    if(ssrules == null) {
	elements = document.getElementsByClassName("aqm" + reportObjId); 
	for(i=0; i<elements.length; i++) {
	    elements[i].style.cssText = cssText[0+status];
	}
    } else {
    /* This works in Firefox 4 */
    for(i=0; i<ssrules.length; i++) {
        if (ssrules[i].selectorText == (".aqm" + reportObjId)) {
		ssrules[i].style.cssText = cssText[0+status];
		break;
	    }
	}
    }

}

/*------------------------------------------------------------
   Display of the Metadata Table
  ------------------------------------------------------------*/
function showTipTable(tableIndex, reportObjId)
{
    var rows = tables[tableIndex].rows;
    var a = reportObjId - 1;

    if(rows.length != arrayMetadata[a].length)
	throw new Error("rows.length=" + rows.length+"  !=  arrayMetadata[array].length=" + arrayMetadata[a].length);

    for(i=0; i<rows.length; i++) 
 	rows[i].cells[1].innerHTML = arrayMetadata[a][i];
}

function hideTipTable(tableIndex)
{
    var rows = tables[tableIndex].rows;

    for(i=0; i<rows.length; i++) 
 	rows[i].cells[1].innerHTML = "";
}


/*------------------------------------------------------------
  From module 'name' (e.g. 'density'), find numeric index in the 
  'svgObjectNames' array.
  ------------------------------------------------------------*/
function getIndexFromName(name) 
{
    var i;
    for(i=0; i<svgObjectNames.length; i++)
        if(svgObjectNames[i] == name)
	    return i;

    throw new Error("Did not find '" + name + "'.");
}


/*------------------------------------------------------------
  SVG plot object callbacks
  ------------------------------------------------------------*/
function plotObjRespond(what, reportObjId, name)
{

    var a, i, status;

    switch(what) {
    case "show":
	i = getIndexFromName(name);
	showTipTable(i, reportObjId);
	break;
    case "hide":
	i = getIndexFromName(name);
	hideTipTable(i);
	break;
    case "click":
        a = reportObjId - 1;
	status = !checkboxes[a].checked;
	checkboxes[a].checked = status;
	setReportObj(reportObjId, status, true);
	break;
    default:
	throw new Error("Invalid 'what': "+what)
    }
}

/*------------------------------------------------------------
  checkboxes 'onchange' event
------------------------------------------------------------*/
function checkboxEvent(reportObjId)
{
    var a = reportObjId - 1;
    var status = checkboxes[a].checked;
    setReportObj(reportObjId, status, true);
}


/*------------------------------------------------------------
  toggle visibility
------------------------------------------------------------*/
function toggle(id){
  var head = safeGetElementById(id + "-h");
  var body = safeGetElementById(id + "-b");
  var hdtxt = head.innerHTML;
  var dsp;
  switch(body.style.display){
    case 'none':
      dsp = 'block';
      hdtxt = '-' + hdtxt.substr(1);
      break;
    case 'block':
      dsp = 'none';
      hdtxt = '+' + hdtxt.substr(1);
      break;
  }  
  body.style.display = dsp;
  head.innerHTML = hdtxt;
}
