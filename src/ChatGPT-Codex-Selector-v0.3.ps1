
# ChatGPT & Codex Launcher - Neon Edition v0.3.0
# Windows PowerShell 5.1 / WPF
# ChatGPT  -> Alt+3 (verified on this PC)
# Codex -> Alt+1 (verified on this PC)
# No browser links. No administrator access required.
# Selection indicates the last requested mode.

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml

# ------------------------------------------------
# CONFIGURATION
# ------------------------------------------------

$script:folder = Join-Path $env:APPDATA 'NeonChatSelector'
$script:file = Join-Path $script:folder 'settings-v0.3.json'

New-Item -ItemType Directory -Path $script:folder -Force |
    Out-Null

$script:cfg = @{
    Name1 = 'ChatGPT'
    Name2 = 'Codex'
    Selected = 0
    Width = 530
    Height = 345
    X = 150
    Y = 150
    TopMost = $true
}

if (Test-Path $script:file) {
    try {
        $saved = Get-Content $script:file -Raw |
            ConvertFrom-Json

        foreach ($key in @($script:cfg.Keys)) {
            if ($null -ne $saved.PSObject.Properties[$key]) {
                $script:cfg[$key] = $saved.$key
            }
        }
    } catch {
        # Preserve safe defaults.
    }
}

function Save-Settings {
    $script:cfg | ConvertTo-Json |
        Set-Content $script:file -Encoding UTF8
}

function Make-Brush([string]$color) {
    $converter = New-Object System.Windows.Media.BrushConverter
    return $converter.ConvertFromString($color)
}

# ------------------------------------------------
# WPF WINDOW AND VISUAL DESIGN
# ------------------------------------------------

$xaml = @'
<Window
 xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
 xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
 Title="ChatGPT &amp; Codex Launcher"
 WindowStyle="None"
 AllowsTransparency="True"
 ResizeMode="NoResize"
 Background="Transparent"
 Width="530" Height="345"
 MinWidth="440" MinHeight="290"
 WindowStartupLocation="Manual"
 ShowInTaskbar="True">

 <Window.Resources>

  <LinearGradientBrush x:Key="BlueOff"
    StartPoint="0,0" EndPoint="1,1">
   <GradientStop Color="#1A2A4C" Offset="0"/>
   <GradientStop Color="#101B36" Offset="0.55"/>
   <GradientStop Color="#172944" Offset="1"/>
  </LinearGradientBrush>

  <LinearGradientBrush x:Key="BlueOn"
    StartPoint="0,0" EndPoint="1,1">
   <GradientStop Color="#3168DE" Offset="0"/>
   <GradientStop Color="#1944B5" Offset="0.5"/>
   <GradientStop Color="#122E83" Offset="1"/>
  </LinearGradientBrush>

  <LinearGradientBrush x:Key="PurpleOff"
    StartPoint="0,0" EndPoint="1,1">
   <GradientStop Color="#39224F" Offset="0"/>
   <GradientStop Color="#261835" Offset="0.55"/>
   <GradientStop Color="#332047" Offset="1"/>
  </LinearGradientBrush>

  <LinearGradientBrush x:Key="PurpleOn"
    StartPoint="0,0" EndPoint="1,1">
   <GradientStop Color="#AC45DF" Offset="0"/>
   <GradientStop Color="#7625B8" Offset="0.55"/>
   <GradientStop Color="#4B187E" Offset="1"/>
  </LinearGradientBrush>

  <Style x:Key="HeaderButton" TargetType="Button">
   <Setter Property="Foreground" Value="#EAF0FF"/>
   <Setter Property="Background" Value="#253553"/>
   <Setter Property="BorderBrush" Value="#4D6287"/>
   <Setter Property="FontFamily" Value="Segoe UI"/>
   <Setter Property="FontWeight" Value="SemiBold"/>
   <Setter Property="FontSize" Value="11"/>
   <Setter Property="Cursor" Value="Hand"/>
   <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
   <Setter Property="Template">
    <Setter.Value>
     <ControlTemplate TargetType="Button">
      <Border x:Name="Chrome"
        CornerRadius="8"
        BorderThickness="1"
        Background="{TemplateBinding Background}"
        BorderBrush="{TemplateBinding BorderBrush}">
       <ContentPresenter
        HorizontalAlignment="Center"
        VerticalAlignment="Center"/>
      </Border>
      <ControlTemplate.Triggers>
       <Trigger Property="IsMouseOver" Value="True">
        <Setter TargetName="Chrome"
          Property="Background" Value="#36517B"/>
        <Setter TargetName="Chrome"
          Property="BorderBrush" Value="#88B7FA"/>
       </Trigger>
       <Trigger Property="IsPressed" Value="True">
        <Setter TargetName="Chrome"
          Property="Background" Value="#15233B"/>
       </Trigger>
      </ControlTemplate.Triggers>
     </ControlTemplate>
    </Setter.Value>
   </Setter>
  </Style>

 </Window.Resources>

 <Border x:Name="Shell"
  Margin="13"
  CornerRadius="19"
  BorderThickness="1"
  BorderBrush="#475A81"
  Background="#0B1020">

  <Border.Effect>
   <DropShadowEffect Color="#000000"
    BlurRadius="23" ShadowDepth="9" Opacity="0.65"/>
  </Border.Effect>

  <Grid>
   <Grid.RowDefinitions>
    <RowDefinition Height="73"/>
    <RowDefinition Height="*"/>
    <RowDefinition Height="43"/>
   </Grid.RowDefinitions>

   <!-- PREMIUM HEADER -->

   <Border Grid.Row="0"
    CornerRadius="18,18,0,0"
    BorderThickness="0,0,0,1"
    BorderBrush="#334562">
    <Border.Background>
     <LinearGradientBrush
      StartPoint="0,0" EndPoint="1,1">
      <GradientStop Color="#202E4B" Offset="0"/>
      <GradientStop Color="#111A30" Offset="0.65"/>
      <GradientStop Color="#121B32" Offset="1"/>
     </LinearGradientBrush>
    </Border.Background>

    <Grid Margin="17,0,13,0">
     <Grid.ColumnDefinitions>
      <ColumnDefinition Width="*"/>
      <ColumnDefinition Width="Auto"/>
     </Grid.ColumnDefinitions>

     <StackPanel x:Name="DragArea"
      Grid.Column="0"
      VerticalAlignment="Center"
      Cursor="SizeAll">
      <TextBlock
       Text="ChatGPT &amp; Codex Launcher"
       Foreground="#F4F7FF"
       FontFamily="Segoe UI"
       FontWeight="SemiBold"
       FontSize="17"/>
      <TextBlock
       Text="NEON EDITION  /  V0.3.0"
       Foreground="#93ABD5"
       FontFamily="Segoe UI"
       FontSize="9"
       Margin="0,5,0,0"/>
     </StackPanel>

     <StackPanel Grid.Column="1"
      Orientation="Horizontal"
      VerticalAlignment="Center">

      <Button x:Name="EditButton"
       Style="{StaticResource HeaderButton}"
       Content="EDIT"
       Width="52" Height="30"
       Margin="0,0,7,0"/>

      <Button x:Name="MinButton"
       Style="{StaticResource HeaderButton}"
       Content="_"
       Width="31" Height="30"
       Margin="0,0,5,0"/>

      <Button x:Name="CloseButton"
       Style="{StaticResource HeaderButton}"
       Content="X"
       Width="31" Height="30"
       Background="#592B40"
       BorderBrush="#AD4B64"/>

     </StackPanel>
    </Grid>
   </Border>

   <!-- TWO BEVELED NEON CARDS -->

   <Grid Grid.Row="1" Margin="19,11,19,7">
    <Grid.ColumnDefinitions>
     <ColumnDefinition Width="*"/>
     <ColumnDefinition Width="14"/>
     <ColumnDefinition Width="*"/>
    </Grid.ColumnDefinitions>

    <!-- CHATGPT -->

    <Border x:Name="BlueCard"
     Grid.Column="0"
     Background="{StaticResource BlueOff}"
     BorderBrush="#456B9D"
     BorderThickness="2"
     CornerRadius="17"
     Cursor="Hand"
     RenderTransformOrigin="0.5,0.5">

     <Border.RenderTransform>
      <ScaleTransform ScaleX="1" ScaleY="1"/>
     </Border.RenderTransform>

     <Border.Effect>
      <DropShadowEffect Color="#43BDFF"
       BlurRadius="16" ShadowDepth="0"
       Opacity="0.22"/>
     </Border.Effect>

     <Grid>

      <!-- Glass-like top shine -->
      <Border Height="42"
       VerticalAlignment="Top"
       Margin="5"
       CornerRadius="13"
       IsHitTestVisible="False">
       <Border.Background>
        <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
         <GradientStop Color="#37FFFFFF" Offset="0"/>
         <GradientStop Color="#00FFFFFF" Offset="1"/>
        </LinearGradientBrush>
       </Border.Background>
      </Border>

      <!-- Raised bevel edge -->
      <Border Margin="4"
       CornerRadius="13"
       BorderThickness="1,1,0,0"
       BorderBrush="#42FFFFFF"
       IsHitTestVisible="False"/>

      <StackPanel VerticalAlignment="Center"
       HorizontalAlignment="Center"
       Margin="9,7,9,7">

       <Viewbox Width="38" Height="38"
        HorizontalAlignment="Center">
        <Canvas Width="48" Height="48">
         <Path Fill="#E3F7FF"
          Data="M27,3 L11,25 L22,25 L18,45 L39,20 L27,20 Z"/>
        </Canvas>
       </Viewbox>

       <TextBlock x:Name="BlueName"
        Text="ChatGPT"
        Foreground="White"
        FontSize="21"
        FontWeight="Bold"
        FontFamily="Segoe UI"
        TextAlignment="Center"
        TextTrimming="CharacterEllipsis"
        MaxWidth="178"
        Margin="0,8,0,0"/>

       <TextBlock Text="CHATGPT"
        Foreground="#C8E4FF"
        FontSize="11"
        TextAlignment="Center"
        Margin="0,4,0,0"/>

       <StackPanel Orientation="Horizontal"
        HorizontalAlignment="Center"
        Margin="0,11,0,0">

        <Ellipse x:Name="BlueDot"
         Width="8" Height="8"
         Fill="#71809C"
         Margin="0,0,7,0"
         VerticalAlignment="Center"/>

        <TextBlock x:Name="BlueState"
         Text="READY"
         Foreground="#9CAECC"
         FontSize="10"
         FontWeight="SemiBold"/>
       </StackPanel>
      </StackPanel>
     </Grid>
    </Border>

    <!-- CODEX -->

    <Border x:Name="PurpleCard"
     Grid.Column="2"
     Background="{StaticResource PurpleOff}"
     BorderBrush="#73528E"
     BorderThickness="2"
     CornerRadius="17"
     Cursor="Hand"
     RenderTransformOrigin="0.5,0.5">

     <Border.RenderTransform>
      <ScaleTransform ScaleX="1" ScaleY="1"/>
     </Border.RenderTransform>

     <Border.Effect>
      <DropShadowEffect Color="#E18AFF"
       BlurRadius="16" ShadowDepth="0"
       Opacity="0.22"/>
     </Border.Effect>

     <Grid>
      <Border Height="42"
       VerticalAlignment="Top"
       Margin="5"
       CornerRadius="13"
       IsHitTestVisible="False">
       <Border.Background>
        <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
         <GradientStop Color="#37FFFFFF" Offset="0"/>
         <GradientStop Color="#00FFFFFF" Offset="1"/>
        </LinearGradientBrush>
       </Border.Background>
      </Border>

      <Border Margin="4"
       CornerRadius="13"
       BorderThickness="1,1,0,0"
       BorderBrush="#42FFFFFF"
       IsHitTestVisible="False"/>

      <StackPanel VerticalAlignment="Center"
       HorizontalAlignment="Center"
       Margin="9,7,9,7">

       <Viewbox Width="43" Height="43"
        HorizontalAlignment="Center">
        <Canvas Width="48" Height="48">
         <Path
          Stroke="#F3D0FF"
          StrokeThickness="2.8"
          StrokeLineJoin="Round"
          StrokeStartLineCap="Round"
          StrokeEndLineCap="Round"
          Fill="Transparent"
          Data="M24,8 C18,1 8,7 10,15
                C3,18 7,27 12,29
                C10,39 20,44 24,35
                M24,8 C30,1 40,7 38,15
                C45,18 41,27 36,29
                C38,39 28,44 24,35
                M24,8 L24,35
                M15,17 L21,23
                M34,17 L27,23"/>
         <Ellipse Canvas.Left="10" Canvas.Top="13"
          Width="5" Height="5" Fill="#F3D0FF"/>
         <Ellipse Canvas.Left="33" Canvas.Top="14"
          Width="5" Height="5" Fill="#F3D0FF"/>
        </Canvas>
       </Viewbox>

       <TextBlock x:Name="PurpleName"
        Text="Codex"
        Foreground="White"
        FontSize="21"
        FontWeight="Bold"
        FontFamily="Segoe UI"
        TextAlignment="Center"
        TextTrimming="CharacterEllipsis"
        MaxWidth="178"
        Margin="0,6,0,0"/>

       <TextBlock Text="CODEX"
        Foreground="#EBCFFF"
        FontSize="11"
        TextAlignment="Center"
        Margin="0,4,0,0"/>

       <StackPanel Orientation="Horizontal"
        HorizontalAlignment="Center"
        Margin="0,11,0,0">

        <Ellipse x:Name="PurpleDot"
         Width="8" Height="8"
         Fill="#71809C"
         Margin="0,0,7,0"
         VerticalAlignment="Center"/>

        <TextBlock x:Name="PurpleState"
         Text="READY"
         Foreground="#9CAECC"
         FontSize="10"
         FontWeight="SemiBold"/>
       </StackPanel>
      </StackPanel>
     </Grid>
    </Border>

   </Grid>

   <!-- PREMIUM STATUS STRIP -->

   <Border Grid.Row="2"
    Background="#111B30"
    BorderThickness="0,1,0,0"
    BorderBrush="#344663"
    CornerRadius="0,0,18,18">

    <Grid Margin="17,0,8,0">
     <Grid.ColumnDefinitions>
      <ColumnDefinition Width="Auto"/>
      <ColumnDefinition Width="*"/>
      <ColumnDefinition Width="Auto"/>
     </Grid.ColumnDefinitions>

     <Ellipse x:Name="StatusDot"
      Grid.Column="0"
      Width="7" Height="7"
      Fill="#7C8FAE"
      VerticalAlignment="Center"
      Margin="0,0,9,0"/>

     <TextBlock x:Name="StatusText"
      Grid.Column="1"
      Text="READY TO SWITCH"
      Foreground="#A7BDE6"
      VerticalAlignment="Center"
      FontSize="10"
      TextTrimming="CharacterEllipsis"/>

     <Thumb x:Name="ResizeGrip"
      Grid.Column="2"
      Width="27" Height="27"
      Cursor="SizeNWSE"
      VerticalAlignment="Bottom"
      HorizontalAlignment="Right">

      <Thumb.Template>
       <ControlTemplate TargetType="Thumb">
        <Grid Width="27" Height="27">
         <Path
          Data="M5,23 L23,5 M13,23 L23,13 M21,23 L23,21"
          Stroke="#89A8D8"
          StrokeThickness="1.6"
          StrokeStartLineCap="Round"/>
        </Grid>
       </ControlTemplate>
      </Thumb.Template>
     </Thumb>

    </Grid>
   </Border>

  </Grid>
 </Border>
</Window>
'@

# ------------------------------------------------
# LOAD WPF INTERFACE
# ------------------------------------------------

$xml = [xml]$xaml
$reader = New-Object System.Xml.XmlNodeReader $xml
$script:window = [Windows.Markup.XamlReader]::Load($reader)

$blueCard = $window.FindName('BlueCard')
$purpleCard = $window.FindName('PurpleCard')
$blueName = $window.FindName('BlueName')
$purpleName = $window.FindName('PurpleName')
$blueDot = $window.FindName('BlueDot')
$purpleDot = $window.FindName('PurpleDot')
$blueState = $window.FindName('BlueState')
$purpleState = $window.FindName('PurpleState')
$statusText = $window.FindName('StatusText')
$statusDot = $window.FindName('StatusDot')
$dragArea = $window.FindName('DragArea')
$resizeGrip = $window.FindName('ResizeGrip')
$editButton = $window.FindName('EditButton')
$minButton = $window.FindName('MinButton')
$closeButton = $window.FindName('CloseButton')

$window.Width = [Math]::Max(440,[int]$script:cfg.Width)
$window.Height = [Math]::Max(290,[int]$script:cfg.Height)
$window.Left = [int]$script:cfg.X
$window.Top = [int]$script:cfg.Y
$window.Topmost = [bool]$script:cfg.TopMost

# ------------------------------------------------
# NEON STATE AND BEVEL EFFECTS
# ------------------------------------------------

function Update-Card($card, [int]$number) {

    $active = ([int]$script:cfg.Selected -eq $number)
    $hover = $card.IsMouseOver

    if ($number -eq 1) {
        $accent = '#70DEFF'
        $on = 'BlueOn'
        $off = 'BlueOff'
        $dot = $blueDot
        $label = $blueState
    } else {
        $accent = '#E99BFF'
        $on = 'PurpleOn'
        $off = 'PurpleOff'
        $dot = $purpleDot
        $label = $purpleState
    }

    if ($active) {
        $card.Background = $window.FindResource($on)
        $card.BorderBrush = Make-Brush $accent
    } else {
        $card.Background = $window.FindResource($off)
        $card.BorderBrush = Make-Brush (
            $(if($hover){$accent}else{'#53617A'})
        )
    }

    $glow = New-Object System.Windows.Media.Effects.DropShadowEffect
    $glow.Color = [System.Windows.Media.ColorConverter]::ConvertFromString(
        $accent
    )
    $glow.ShadowDepth = 0

    if ($active) {
        $glow.BlurRadius = 37
        $glow.Opacity = 0.90
    } elseif ($hover) {
        $glow.BlurRadius = 29
        $glow.Opacity = 0.65
    } else {
        $glow.BlurRadius = 15
        $glow.Opacity = 0.15
    }

    $card.Effect = $glow

    if ($active) {
        $dot.Fill = Make-Brush '#9DFFB6'
        $label.Text = 'ACTIVE'
        $label.Foreground = Make-Brush '#BBFFCF'
    } else {
        $dot.Fill = Make-Brush '#7283A2'
        $label.Text = 'READY'
        $label.Foreground = Make-Brush '#A3B1CC'
    }
}

function Update-Visuals {

    $blueName.Text = [string]$script:cfg.Name1
    $purpleName.Text = [string]$script:cfg.Name2

    Update-Card $blueCard 1
    Update-Card $purpleCard 2

    $statusText.Text = switch ([int]$script:cfg.Selected) {
        1 { "LAST REQUESTED: $($script:cfg.Name1.ToUpper()) / CHATGPT" }
        2 { "LAST REQUESTED: $($script:cfg.Name2.ToUpper()) / CODEX" }
        default { 'READY TO SWITCH' }
    }

    $statusDot.Fill = if ([int]$script:cfg.Selected -eq 0) {
        Make-Brush '#8194B5'
    } else {
        Make-Brush '#9DFFB6'
    }
}

# ------------------------------------------------
# SMOOTH HOVER ANIMATION
# ------------------------------------------------

function Animate-Card($card, [bool]$hover) {

    $transform = $card.RenderTransform

    $target = if ($hover) { 1.035 } else { 1.0 }

    $duration = [System.Windows.Duration]::new(
        [TimeSpan]::FromMilliseconds(150)
    )

    $animX = New-Object System.Windows.Media.Animation.DoubleAnimation
    $animX.To = $target
    $animX.Duration = $duration

    $animY = New-Object System.Windows.Media.Animation.DoubleAnimation
    $animY.To = $target
    $animY.Duration = $duration

    $transform.BeginAnimation(
        [System.Windows.Media.ScaleTransform]::ScaleXProperty,
        $animX
    )

    $transform.BeginAnimation(
        [System.Windows.Media.ScaleTransform]::ScaleYProperty,
        $animY
    )
}

$blueCard.Add_MouseEnter({
    Animate-Card $blueCard $true
    Update-Card $blueCard 1
})

$blueCard.Add_MouseLeave({
    Animate-Card $blueCard $false
    Update-Card $blueCard 1
})

$purpleCard.Add_MouseEnter({
    Animate-Card $purpleCard $true
    Update-Card $purpleCard 2
})

$purpleCard.Add_MouseLeave({
    Animate-Card $purpleCard $false
    Update-Card $purpleCard 2
})

# ------------------------------------------------
# DESKTOP MODE SWITCHING
# Preserves the working mappings from v0.2.
# ------------------------------------------------

function Invoke-Mode([int]$number) {

    try {
        $app = Get-Process -Name 'ChatGPT' -ErrorAction SilentlyContinue |
            Where-Object {
                $_.MainWindowHandle -ne 0 -and
                $_.MainWindowTitle -match 'ChatGPT|Codex'
            } |
            Select-Object -First 1

        if (-not $app) {
            throw 'Please open the ChatGPT desktop app first.'
        }

        $shell = New-Object -ComObject WScript.Shell

        if (-not $shell.AppActivate([int]$app.Id)) {
            throw 'Could not focus the ChatGPT desktop app.'
        }

        Start-Sleep -Milliseconds 400

        if ($number -eq 1) {
            $shell.SendKeys('%3')  # ChatGPT
        } else {
            $shell.SendKeys('%1')  # Codex
        }

        $script:cfg.Selected = $number
        Update-Visuals
        Save-Settings

    } catch {
        [System.Windows.MessageBox]::Show(
            "Mode switch failed: $($_.Exception.Message)",
            'ChatGPT & Codex Launcher'
        ) | Out-Null
    }
}

$blueCard.Add_MouseLeftButtonUp({
    Invoke-Mode 1
})

$purpleCard.Add_MouseLeftButtonUp({
    Invoke-Mode 2
})

# ------------------------------------------------
# CUSTOM WINDOW CONTROLS
# ------------------------------------------------

$dragArea.Add_MouseLeftButtonDown({
    if ($_.ChangedButton -eq
        [System.Windows.Input.MouseButton]::Left) {
        try { $window.DragMove() } catch {}
    }
})

$minButton.Add_Click({
    $window.WindowState = 'Minimized'
})

$closeButton.Add_Click({
    $window.Close()
})

$resizeGrip.Add_DragDelta({
    param($sender,$e)

    $window.Width = [Math]::Max(
        $window.MinWidth,
        $window.Width + $e.HorizontalChange
    )

    $window.Height = [Math]::Max(
        $window.MinHeight,
        $window.Height + $e.VerticalChange
    )
})

# ------------------------------------------------
# CUSTOM SETTINGS DIALOG
# ------------------------------------------------

$editButton.Add_Click({

    $dialogXaml = @'
<Window
 xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
 xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
 Title="Selector settings"
 Width="400" Height="310"
 Background="#10182C"
 Foreground="#F0F4FF"
 WindowStartupLocation="CenterOwner"
 ResizeMode="NoResize"
 WindowStyle="ToolWindow">

 <StackPanel Margin="22">

  <TextBlock Text="CUSTOMIZE YOUR SELECTOR"
   FontSize="15" FontWeight="Bold"
   Foreground="#E5EFFF"
   Margin="0,0,0,19"/>

  <TextBlock Text="BLUE BUTTON NAME"
   FontSize="10" Foreground="#84BFFF"/>

  <TextBox x:Name="EditBlue"
   Height="28" Margin="0,6,0,15"
   Padding="7,4"
   Background="#263752"
   Foreground="White"
   BorderBrush="#6387BE"/>

  <TextBlock Text="PURPLE BUTTON NAME"
   FontSize="10" Foreground="#D4A1FF"/>

  <TextBox x:Name="EditPurple"
   Height="28" Margin="0,6,0,15"
   Padding="7,4"
   Background="#352447"
   Foreground="White"
   BorderBrush="#9865C3"/>

  <CheckBox x:Name="TopCheck"
   Content="Keep widget always on top"
   Foreground="#D2DDF5"
   Margin="0,1,0,18"/>

  <StackPanel Orientation="Horizontal"
   HorizontalAlignment="Right">

   <Button x:Name="CancelButton"
    Content="CANCEL" Width="82" Height="30"
    Margin="0,0,10,0"/>

   <Button x:Name="SaveButton"
    Content="SAVE" Width="82" Height="30"
    Background="#275BC4"
    Foreground="White"
    FontWeight="Bold"/>
  </StackPanel>

 </StackPanel>
</Window>
'@

    $dialogDoc = [xml]$dialogXaml
    $dialogReader = New-Object System.Xml.XmlNodeReader $dialogDoc
    $dialog = [Windows.Markup.XamlReader]::Load($dialogReader)

    $dialog.Owner = $window

    $editBlue = $dialog.FindName('EditBlue')
    $editPurple = $dialog.FindName('EditPurple')
    $topCheck = $dialog.FindName('TopCheck')
    $saveButton = $dialog.FindName('SaveButton')
    $cancelButton = $dialog.FindName('CancelButton')

    $editBlue.Text = [string]$script:cfg.Name1
    $editPurple.Text = [string]$script:cfg.Name2
    $topCheck.IsChecked = [bool]$script:cfg.TopMost

    $cancelButton.Add_Click({
        $dialog.DialogResult = $false
    })

    $saveButton.Add_Click({

        if ([string]::IsNullOrWhiteSpace($editBlue.Text) -or
            [string]::IsNullOrWhiteSpace($editPurple.Text)) {

            [System.Windows.MessageBox]::Show(
                'Both buttons need a name.',
                'Selector settings'
            ) | Out-Null

            return
        }

        $script:cfg.Name1 = $editBlue.Text.Trim()
        $script:cfg.Name2 = $editPurple.Text.Trim()
        $script:cfg.TopMost = [bool]$topCheck.IsChecked

        $window.Topmost = [bool]$script:cfg.TopMost

        Update-Visuals
        Save-Settings

        $dialog.DialogResult = $true
    })

    [void]$dialog.ShowDialog()
})

# ------------------------------------------------
# SAVE WINDOW SIZE AND POSITION
# ------------------------------------------------

$window.Add_Closing({

    if ($window.WindowState -eq
        [System.Windows.WindowState]::Normal) {

        $script:cfg.Width = [int]$window.Width
        $script:cfg.Height = [int]$window.Height
        $script:cfg.X = [int]$window.Left
        $script:cfg.Y = [int]$window.Top
    }

    Save-Settings
})

# ------------------------------------------------
# LAUNCH
# ------------------------------------------------

Update-Visuals

[void]$window.ShowDialog()
