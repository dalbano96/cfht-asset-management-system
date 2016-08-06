<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Labels</title>
    <link href="labels.css" rel="stylesheet" type="text/css" >
    <style>
    body {
        width: 8.5in;
	margin-top: 0in !important;
	padding-bottom: 0px !important;
	margin-bottom: 0px !important;
        }
    .label{
        /* Avery 5160 labels -- CSS and HTML by MM at Boulder Information Services */
        width: 3.25in; /* plus .6 inches from padding */
        height: .94in; /* plus .125 inches from padding */
	padding: .08in;
	//margin: .08in;
       // padding: .4in .4in .4in .4in;
       // margin-right: .125in; /* the gutter */

        float: left;

        overflow: hidden;

        outline: none; /* outline doesn't occupy space like border does */
        }
    	.page-break  {
        	clear: left;
        	display:block;
       	 	page-break-after:always;
       	 }
	.qr_img {
		float: right;
		//margin-left: .12in;
		height: .7in;
		width: .7in;
		padding-top: .12in;
		padding-bottom: .12in;
		//margin-top: .12in;
		//margin-bottom: .12in;
		//max-width: 30%;
		//max-height: auto;
		
	    }

	 .qr_text {
		float: left;
		font-family: arial, helvetica, sans-serif;
		font-size: 7pt;
		padding-right: .1in;
		margin-top: .12in;
	    }

@page {
	width: 3.5in;
	margin-left: 0px;
	margin-right: 0px;
	margin-top: 0px;
	margin-bottom: 0px;
}


@media print {	
	.label {
		width: 4.5in;
	}
	
	.qr_img {
		width: .9in;
		height: .9in;
	}

	.qr_text {
		font-size: 11pt;
	}
}



    </style>

</head>
<body>


@foreach ($assets as $asset)
	<?php $count++; ?>
	<div class="label">
		<div class="qr_img"><img src="./{{{ $asset->id }}}/qr_code"; width=100%; height=100%;></div>
		<div class="qr_text">
			<b>Property of Canada France Hawaii Telescope</b>
			<br>
			<b>Phone: (808) 885-7944</b>
			<br>
			<b>Email: software@cfht.hawaii.edu</b>
			<br>
			
			<!--@if ($settings->qr_text!='')
				{{{ $settings->qr_text }}}
				
			@endif -->
            		<!--@if ($asset->name!='')
                		<b>N: {{ $asset->name }}</b>
                		<br>
            		@endif-->
			@if ($asset->asset_tag!='')
				{{{ $asset->asset_tag }}}
				<br>
			@endif
			@if ($asset->serial!='')
				S/N: {{{ $asset->serial }}}
				<br>
			@endif

		</div>
	</div>
	 @if ($count % 1 == 0)
		<div class="page-break"></div>

	@endif

@endforeach



</body>
</html
