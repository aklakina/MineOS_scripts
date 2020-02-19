Add-Type -AssemblyName PresentationFramework
$IE= new-object -ComObject "InternetExplorer.Application"
$ie.visible=$true
$ie.Navigate("about:blank")
$ie.statusbar=0
$ie.AddressBar=0
$ie.MenuBar=0
$ie.Document.body.outerHTML=@'
<!DOCTYPE html>
<html lang="hu" dir="ltr">

<head>
    <meta charset="utf-8">
    <title>Házi másoló</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>

<body>


    <a class="container1 mr-5"  href="https://gitlab.com/crafty-controller/crafty-web/-/wikis/home" target="_blank"> Crafty
        wiki
    </a>
    <a class="container1 mr-5" 
        href="https://craftycontrol.com/docs/" target="_blank"> Crafty documentation

    </a>
    <div class="wrapper d-flex flex-row m-auto w-75 justify-content-center">
        <div class="container1 mr-5">
			<a href="#" class="btn btn-primary btn-lg active" role="button" aria-pressed="true"
                onclick="javascript:document.getElementById('info').value='start'"> Install</a>
			<a href="#" class="btn btn-primary btn-lg active" role="button" aria-pressed="true"
                onclick="javascript:document.getElementById('info').value='show'">Show me what is inside my selected directory</a>
        </div>
        <div class="container2 ml-5">
            <label class="d-block mb-2" for="input1"> Install directory:</label>
			<input type="text" placeholder="Directory" id="input1" name="input1">
            <a class="d-block mb-2"> Installable options:</a>
            <input type="checkbox" id="python" name="v" value="true">
			<label for="python"> Python</label><br>
			<input type="checkbox" id="vehicle2" name="service" value="true">
			<label for="service"> Crafty (service)</label><br>
			<a class="d-block mb-2"> (You can enable this later on by running this again and only checking this option)</a>
			<input type="checkbox" id="main" name="main" value="true">
			<label for="main"> Crafty (main)</label><br>
			<input type="checkbox" id="updater" name="updater" value="true">
			<label for="updater"> Crafty updater</label><br>
			<input id="info" type="hidden" value="">


            <a href="#" id="exit" class="btn btn-secondary btn-lg active d-block mt-5" role="button" aria-pressed="true"
                onclick="javascript:document.getElementById('info').value='Kilepes'">Exit</a>

        </div>



		<textarea id="mapp" style="position:absolute;bottom:180px;left:30px;width:100px;height:180px"></textarea>
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous">
        </script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
            integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous">
        </script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
            integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
        </script>
</body>

</html>
'@
$doc=$ie.document
$infoFld = $doc.getElementById("info")
$cont=$false
$env:Path += ";$(Get-Location)\NSSM\win64;C:\Python27amd64\Scripts"
while ($true){
while(!($infoFld.value)){start-sleep -Milliseconds 300}
$HomeDir=$doc.getElementById("input1").value
if ($infoFld.value -eq "Kilepes") {
        $ie.quit()
	    exit 0
    }  elseif (!($Homedir)){
		[System.Windows.MessageBox]::Show('You did not set any directory to install.','???','Ok','error')
		$infoFld.value=''
	}
if($infofld.value -eq "show") {
	$doc.getElementById("mapp").value=''
	$string=""
	$rootPath="$HomeDir"
	Get-ChildItem -Path $rootPath -Depth 0 -Directory|%{
		$string+="$_
"
	}
	$infoFld.value=''
    $doc.getElementById("mapp").value=$string
	$infoFld.value=''
} elseif($infofld.value -eq "start") {
	if ($doc.getElementById("python").Checked) {
		./PythonInstaller.exe PrependPath=1 AssociateFiles=1 Include_lib=1 Include_pip=1 Include_tcltk=1 Include_tools=1 /quiet
	}
	if ($doc.getElementById("main").Checked) {
		$testchoco = powershell choco -v
			if(-not($testchoco)){
				./gitinstaller.ps1
				echo "You may need to restart the script for the git actions to work properly."
			}
		git clone https://gitlab.com/crafty-controller/crafty-web.git $HomeDir
		pip install -r "$HomeDir\requirements.txt"
	}
	if (($doc.getElementById("service").Checked -and $doc.getElementById("main").Checked) -or (Test-Path $HomeDir\NSSM\win64\nssm.exe -PathType Leaf)) {
		nssm install CraftyController  $HomeDir\crafty.py -d
		nssm set CraftyController AppDirectory $HomeDir
		nssm start CraftyController
	}
	if ($doc.getElementById("updater").Checked) {
		Expand-Archive ./Git.zip -DestinationPath "$HomeDir\GitPortable"
		cd $HomeDir
		new-item update_crafty.bat
		set-content update_crafty.bat 'set git="$HomeDir\GitPortable\cmd\git.exe"'
		add-content update_crafty.bat 'cd Crafty'
		add-content update_crafty.bat '%git% pull'
	}
}
$infoFld.value=''
}