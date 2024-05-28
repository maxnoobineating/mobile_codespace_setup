# Import-Module ./Docker_images_utils.ps1
# to use:
# $devcontainer = [DevContainer]::new("default-devcontainer", "ubuntu-devcontainer:latest", "ubuntu-base-image:latest", "devcontainer_workspace")
# or more comprehensively, for optional parameter:
# $devcontainer = New-Object -TypeName DevContainer -ArgumentList @{'Name'='my-devcontainer'; 'Image'='my-image'}

# $devcontainer.New-Ubuntu_BaseImage()
# $devcontainer.Set-Ubuntu_Devcontainer_ImageSetup()
# $devcontainer.New-DevContainer()
# $devcontainer.Set-Start_DevContainer()
# $devcontainer.Set-Stop_DevContainer()

class DevContainer {
    [string]$Name
    [string]$Image
    [string]$BaseImage
    [string]$Volume
    [string]$ClipPath_host=$(Join-Path $PWD.PATH "clipboard.txt")
    [string]$ClipPath_container="/mnt/c/clipboard.txt"
    [string]$ClipExePath="C:\Windows\System32\clip.exe"
    [System.Management.Automation.Job]$clipping_subprocess
    
    DevContainer([string]$Name, [string]$Volume) {
        $this.Name = $Name
        $this.Volume = $Volume 
        $this.Image = "ubuntu-devcontainer:latest"
        $this.BaseImage = "ubuntu-base-image:latest"
    }
    
    DevContainer([string]$Name, [string]$Volume, [string]$Image, [string]$BaseImage) {
        $this.Name = $Name
        $this.Volume = $Volume 
        $this.Image = $Image
        $this.BaseImage = $BaseImage
    }
    
    [void] Set_Start_DevContainer() {
        New-Item -Path $this.ClipPath_host -ItemType File -Force
        $script_block = {
            param([string]$ClipExePath, [string]$ClipPath_host)
            $lastWriteFile = Get-Item $ClipPath_host
            while ($true) {
                Start-Sleep -Seconds 1
                $currentWriteFile = Get-Item $ClipPath_host
                if ($currentWriteFile.LastWriteTime.ticks -ne $lastWriteFile.LastWriteTime.ticks) {
                    Get-Content $currentWriteFile | & $ClipExePath
                    $lastWriteFile = $currentWriteFile
                }
            }
        }
        $this.clipping_subprocess = Start-Job -scriptblock $script_block -ArgumentList $this.ClipExePath, $this.ClipPath_host
        docker start $this.Name
        docker exec -it $this.Name dotfile pull
        Write-Output "Container $($this.Name) started"
    }

    [void] Set_Stop_DevContainer() {
        docker stop $this.Name
        Stop-Job -Job $this.clipping_subprocess
        Remove-Job -Job $this.clipping_subprocess
        "Container $($this.Name) stopped and removed"
    }

    [void] New_DevContainer() {
        # [CmdletBinding()]
        # param (
        #     [Parameter()]
        #     [string]$Name = "default-devcontainer",
        #     [string]$Image = "ubuntu-devcontainer:latest",
        #     [string]$Volume = "devcontainer_workspace"
        # )
        # docker run -itd --name $Name -v "$Volume":/root/"$Volume" -v 
        # docker run -itd --name $Name -v "$Volume":/root/"$Volume" -v  <path to: C:\Windows\System32\clip.exe>:/mnt/c/Windows/System32/clip.exe $Image
        docker create -it --name $this.Name -v "$($this.Volume):/root/$($this.Volume)" -v "$($this.ClipPath_host):$($this.ClipPath_container)" $this.Image
        "Container $($this.Name) created from $($this.Image)"
    }

    [void] Set_Ubuntu_ImageUpdate([string] $UpdatedImage=$this.Image) {
        # [CmdletBinding()]
        # param (
        #     [Parameter()]
        #     [string]$Image = "ubuntu-devcontainer:latest"
        # )
        docker build --build-arg BASE_IMAGE=$UpdatedImage -t $UpdatedImage -f ./dockerfileUpdate.dockerfile .
        "Image $UpdatedImage updated"
    }

    [void] Set_UbuntuDevcontainerImageSetup() {
        # [CmdletBinding()]
        # param (
        #     [Parameter()]
        #     [string]$BaseImage = "ubuntu-base-image:latest",
        #     [string]$Name = "ubuntu-devcontainer:latest"
        # )
        docker build --build-arg BASE_IMAGE=$this.BaseImage -t $this.Name -f ./dotfile_setup.dockerfile .
        "Image $($this.Name) dotfiles/packages setup complete"
    }

    [void] New_UbuntuBaseImage() {
        # [CmdletBinding()]
        # param (
        #     [Parameter()]
        #     [string]$Name = "ubuntu-base-image:latest"
        # )
        docker build -t $this.BaseImage -f ./dockerfile_base.dockerfile .
        "Base image $($this.BaseImage) created"
    }
}