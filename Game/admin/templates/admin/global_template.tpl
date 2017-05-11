<html>
<head>
    <title>Mail Message</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
</head>
<body style="background: #fff; margin: 0;">
    <table width="100%" cellpadding="0" cellspacing="0">
    <tr><td>
        <div>
            {$message}
        </div>
    </td></tr>
    <tr><td>
        <div>
            {block name="content"}{/block}
        </div>
    </td></tr>
    </table>
</body>
{* original
    <body>
        <div id="header">
            <a href="{$site_url}"><img src="{$site_url}interface/logo_mail.png" alt="KaiKo" /></a>
        </div>
        <div id="body">
            {$message|default:'<p>Your text will appear here</p>'}
    </body>
    {literal}
    <style type="text/css">
        body { background: #fff; margin: 0;}
        #header { background: url({$site_url}interface/header_bg.gif) repeat-x top; }
        #header img { margin: 35px 0 0 10px;}
        #body, #footer {
            padding: 10px;
            font-size: 11pt;
            font-family: Calibri, "Trebuchet MS", Verdana, Arial, sans-serif;
        }
        #footer {
            margin-top: 20px;
            border-top: 1px dotted #ddd;
            font-size: 9pt;
            padding: 5px 10px;
            color: #555;
        }
        img { border: none; }
    </style>
    {/literal}
*}
</html>