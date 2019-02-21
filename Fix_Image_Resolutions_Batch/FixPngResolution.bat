rem ============================================================================
rem title          :FixPngResolution.bat
rem description    :This script is used for batch changing of photo resolution in a folder and all of its subdirectories.
rem author         :Ivan Zagar
rem date           :20190221
rem version        :1.0.0  
rem usage          :FixPngResolution.bat
rem notes          : 
rem ============================================================================

@echo off
setlocal EnableDelayedExpansion

echo 'Changing resolution of .png images'
echo 
echo "========================= START ========================="

set resolution=96
set imagePath="C:\Users\%USERNAME%\Desktop\Images"
set programPath="C:\Program Files\ImageMagick-7.0.8-Q16\magick.exe"

IF NOT EXIST %imagePath% ( 
	echo Image path folder does not exists ! Aborting !
	goto :END 
)

IF NOT EXIST %programPath% ( 
	echo Program path folder does not exists! Aborting!
	goto :END 
)

rem Za svaki .png file u /Images folderu spremi njegovu putanju u output.txt
dir %imagePath% /s /b *.png > output.txt
		
for /F "tokens=*" %%A in (output.txt) do (

	rem %%A ce vratiti path do slike (sa imenom slike + ekstenzijom)
	rem dir nardba iznad vraca i sam folder, stoga treba te linije preskociti sa provjerom ako je trenutni string file (.png) ili folder
	IF NOT EXIST %%A\NUL ( 

		echo Converting image: %%A
		rem poziv magick.exe-a, promjena resolution-a, te kreiranje novog file-a "%%A_1"
		call %programPath% convert -units PixelsPerInch -density %resolution% %%A "%%A_1"
		
		rem obrisi originalnu sliku
		del %%A
		
		rem preimenovaj convertiranu sliku natrag u originalnu
		ren "%%A_1" %%~nxA

	) else (
		echo "%%A is a folder, skipping."
	)		
)

rem obrisi viska file
del output.txt

echo 
:END
echo "========================= FINISHED ========================="
set /p ENTER="Hit ENTER to exit script..."