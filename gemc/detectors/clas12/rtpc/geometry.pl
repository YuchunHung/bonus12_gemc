use strict;
use warnings;

our %configuration;

#our $thisVariation = $configuration{"variation"} ;
###########################################################################################
# All dimensions in mm
our $z_shift = 30.0;
    
our $z_half = 200.0;
our @zhalf = ($z_half + 23.0, $z_half, $z_half);
our $gap = 0.0001; # Make sure the geometry setup di not overlap between each component. Origial was 0.001 mm (1 micron).

# Target Wall, Ground foil, Cathod foil (al layer neglected)
our @radius  = (3.0, 20.0, 30.0); # mm
our @thickness = (0.063, 0.006, 0.004); # mm (i.e. 55 um, 6 um, 4 um)
our @layer_mater = ('G4_KAPTON', 'G4_MYLAR', 'G4_MYLAR');
our @layer_color = ('330099', 'aaaaff', 'aaaaff');

# GEM Layer parameters
our @gem_radius = (70.0, 73.0, 76.0); # mm
our @gem_thick = (0.005, 0.05, 0.005); # 5um, 50um, 5um
our @gem_mater = ( 'G4_Cu', 'G4_KAPTON', 'G4_Cu');
our @gem_color = ('330099',  '661122', '330099');

# Transfer region parameters
our $trans_Rmin = 0; # The value will be assigned in make_gems(), which would be related the position of the last layer of the GEM foil.

# seam phi regions (358.775, 360.0) and (0.0, 1.225)
# Mohammad: The seam is 2.45 degress in phi, centerd arouud zero phi,
#  I had to break it around zero to too sectors of 1.225 degrees each
#  the lower part does not take 360 deg as the upper limit, I put it to 1.225 but in reality it 
#  takes it up to 360
our @seam_phi_start = (358.775, 0.0); # degrees 
our @seam_phi_end   = (1.225, 1.225); # degrees 

# Readout pad parameters
our $pad_layer_radius = 79.0; # mm  
our @pad_layer_color = ('aaafff');
our $pad_layer_thick = 0.2794; # 11 mils  = 0.2794 mm

#seam phi region of the padboard 2.0 degrees in phi centered at 0
our @pad_seam_phi_start = (359.0001, 0.0); #(359.25, 0.0); #degrees
our @pad_seam_phi_end = (1.0, 1.0);  #degrees 

# Electronics/Ribs/Spines (ERS) Layer
our $ers_layer_radius = $gap + $pad_layer_radius + $pad_layer_thick; # mm
our $ers_layer_thick = 5.0; # mm
our @ers_layer_color = ('ffd56f');

# protection circuits
our $prot_radius = $gap + $ers_layer_radius + $ers_layer_thick; # mm
our $prot_length = 35.5; # mm
our $prot_thick = 3.373; # mm        <===- NEEDS TO BE CHANGED/VERIFIED
our @prot_color = ('000000');

# Translation board parameters
our $Tboard_radius = $gap + $ers_layer_radius + $ers_layer_thick; # mm
our $Tboard_length = 106.8; # mm
our $Tboard_thick = 0.32; # mm (11 mils)
our @Tboard_color = ('ace4d2');

# Downstream end-plate assembly parameters
# layer
# 1 Target support block 1
# 2 Target support block 2
# 3 Cathode assembly inner ring
# 4 Cathode assembly outer ring
# 5 Field cage
# 6 Field cage spacer
# 7 GEM Rings
# 8 DS plate
# 9 DS plate inner ring
# 10 DS plate outer ring
our @dsep_rmin = (16.764,    3.0555, 20.07,  30.06,  32.01,  36.80,  67.10,  32.01,  32.01,  76.0); # mm
our @dsep_rmax = (20.06,     25.44,  30.05,  32.0,   67.09,  40.00,  75.90,  84.0,   33.0,   78.0); # mm
our @dsep_thick = (9.63,     3.05,   16.0,   16.0,   1.0,    7.21,   4.0,    2.00,   1.0,    2.0); # mm
our @dsep_zloc = (16.0-$dsep_thick[0]/2.0,
                16.0+$dsep_thick[1]/2.0+$gap,
                $dsep_thick[2]/2.0+$gap,
                $dsep_thick[3]/2.0+$gap,
                $dsep_thick[4]/2.0+$gap,
                $dsep_thick[4]+$dsep_thick[5]/2.0+$gap,
                $dsep_thick[6]/2.0+$gap,
                6.0 + $dsep_thick[7]/2.0+$dsep_thick[9]+$gap,
                6.0 + $dsep_thick[7]+$dsep_thick[9]+$dsep_thick[8]/2.0+$gap,
                6.0 + $dsep_thick[9]/2.0+$gap); # mm
our @dsep_color = ('fff933', 'fff933', 'ff3349', '808080', '078542', 'fff933', '808080', "99ff33", "99ff33", "99ff33");
our @dsep_mat = ('Rohacell', 'Rohacell', 'Rohacell', 'Ultem', 'G10', 'Rohacell', 'Ultem', 'G10', 'G10', 'G10');

# Upstream end-plate
our @usep_radius = (3.056, 84.0); # mm
our $usep_thick = 2.00; # mm
our $usep_zloc = -$zhalf[1]-$usep_thick/2.0-8.0; # mm
our @usep_color = ('99ff33');
our @usep_mat = ("G10");

# Snout
# layer
# 1 He from target end cap to wall
# 2 He from end cap to end of snout
# 3 Kapton wall

our $snout_endz = 824.2;
our @snout_rmin = (3.156, 0, 22.06); # mm
our @snout_rmax = (22.54, 22.54, 22.55); # mm
our @snout_thick = (2.11, $snout_endz-$zhalf[1] + $dsep_thick[2] + 2.11,$snout_endz-$zhalf[1] + $dsep_thick[2]); # mm
our @snout_zloc = ($zhalf[1] + $dsep_zloc[1] + $dsep_thick[1]/2.0 + $snout_thick[0]/2.0 + $gap,
                  $zhalf[1] + $dsep_zloc[1] + $dsep_thick[1]/2.0 + $snout_thick[1]/2.0 + $gap,
                  $zhalf[1] + $dsep_zloc[1] + $dsep_thick[1]/2.0 + $snout_thick[2]/2.0 + $gap); # mm
			  #     our @snout_color = ('ffffff', 'ffffff', 'fb06ff');
our @snout_color = ('ff9933', '7030a0', 'fb06ff');
our @snout_mat = ("G4_He", "G4_He", "G4_KAPTON");


#################### sun-function ########################

# mother volume
sub make_rtpc
{
    my %detector = init_det();
    $detector{"name"}        = "rtpc";
    $detector{"mother"}      = "root";
    $detector{"description"} = "Radial Time Projecion Chamber";
    $detector{"color"}       = "eeeegg";
    $detector{"type"}        = "Tube";
    $detector{"dimensions"}  = "0*mm 200.0*mm 255.0*mm 0*deg 360*deg";
    $detector{"material"}    = "G4_He";
    $detector{"visible"}     = 0;
    print_det(\%configuration, \%detector);
}

sub make_layers
{
    my $layer = shift;
        
    my $rmin  = 0;
    my $rmax  = 0;
    my $phistart = 0;
    my $pspan = 360;
    my $mate  = "G4_He";
    my %detector = init_det();
        
    # target wall $layer==0
    # ground foil $layer==1
    # cathode $layer==2
    $rmin  = $radius[$layer];
    $rmax  = $rmin + $thickness[$layer];
    $mate  = $layer_mater[$layer];
    my $z_lay = $zhalf[$layer];
        
    $detector{"name"} = "layer_".$layer;
    $detector{"mother"}      =  "rtpc";
    $detector{"description"} = "Layer ".$layer;
    $detector{"color"}       = $layer_color[$layer];
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_lay*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}


# target gas inside the target wall (20mm)
sub make_targetGas
{
    my $rmin  = 0;
    my $rmax  = $radius[0] - $gap;
    my $phistart = 0;
    my $pspan = 360;
    my %detector = init_det();
    my $mate  = "Air";
	my $z_target = $zhalf[0];
	if ($configuration{"variation"} eq "hydrogenTarget") {
		$mate = "HydrogenTargetGas";
	}
	elsif ($configuration{"variation"} eq "heliumTarget") {
		$mate = "HeliumTargetGas";
	}
	else {
		$mate = "DeuteriumTargetGas";
	}

        
    $detector{"name"} = "target_Gas";
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "Target Gas";
    $detector{"color"}       = "72d3fa";
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_target*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}

# Buffer volume between target and ground foil (20mm)
sub make_buffer_volume
{
    my $rmin  = $radius[0] + $thickness[0] + $gap;
    my $rmax  = $radius[1] - $gap;
    my $phistart = 0;
    my $pspan = 360;
    my %detector = init_det();
    my $mate  = "BONuSGas";
        
    $detector{"name"} = "buffer_layer";
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "Buffer volume";
    $detector{"color"}       = "f0f8ff";
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}


# Buffer volume between ground foil and cathode (30mm)
sub make_buffer2_volume
{
    my $rmin  = $radius[1] + $thickness[1] + $gap;
    my $rmax  = $radius[2] - $gap;
    my $phistart = 0;
    my $pspan = 360;
    my %detector = init_det();
    my $mate  = "BONuSGas";
        
    $detector{"name"} = "buffer2_layer";
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "Buffer volume";
    $detector{"color"}       = "e0ffff";
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}


# three gem
sub make_gems
{
    my $gemN = shift;
    my $layer = shift;
        
    my $rmin  = 0;
    my $rmax  = 0;
    my $color = "000000";
    my $mate  = "Air";
    my $phistart = 1.225;
    my $pspan = 357.55;
    my %detector = init_det();
        
    $rmin  = $gem_radius[$gemN];
        
	for (my $l = 0; $l < $layer; $l++) {
		$rmin = $rmin + $gem_thick[$l] + $gap;
	}
        
    $rmax  = $rmin + $gem_thick[$layer];
    $color = $gem_color[$layer];
    $mate  = $gem_mater[$layer];
	#print "gem$gemN layer$layer, rmin = $rmin, rmax = $rmax\n";
	
	$trans_Rmin = $rmax;
        
    $detector{"name"} = "gem_".$gemN."_layer_".$layer;
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "gem_".$gemN."_layer_".$layer;
    $detector{"color"}       = $color;
    $detector{"type"}        = "Tube";
    $detector{"style"}       = 1;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    print_det(\%configuration, \%detector);
        
}

sub make_gems_seam
{
    my $gemN = shift;
    my $region = shift;  

    my $rmin  = 0;
    my $rmax  = 0;
    my $color = "661122";
    my $mate  = "G4_KAPTON";
    my $phistart = $seam_phi_start[$region] + $gap;
    my $pspan = $seam_phi_end[$region] - $gap;
    my %detector = init_det();
        
    $rmin  = $gem_radius[$gemN];
    $rmax  = $rmin + 0.1;   # 100 microns kapton
        
        
    $detector{"name"} = "gem_seam".$gemN."_region_".$region;
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "gem_seam".$gemN."_region_".$region;
    $detector{"color"}       = $color;
    $detector{"type"}        = "Tube";
    $detector{"style"}       = 1;
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    print_det(\%configuration, \%detector);
        
}

# make drift volume from cathode to first GEM (30-70 mm)
sub make_drift_volume
{
    my $rmin  = $radius[2] + $thickness[2] + $gap;
    my $rmax  = $gem_radius[0] - $gap;
    my $pspan = 360.;
    my $phistart = 0;
    my %detector = init_det();
    my $mate  = "BONuSGas";

    $detector{"name"} = "sensitive_drift_volume";
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "Sensitive drift volume";
    $detector{"color"}       = "ff8894";#"ff88994";
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    $detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    $detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}

# make transfer volumes between three GEM foils (70-79 mm)
sub make_transfer_volume
{
	my $trans = shift;

    my $rmin  = $trans_Rmin + $gap;
    my $rmax  = $gem_radius[$trans] + 3.0 - $gap;
    my $phistart = 1.225;
    my $pspan = 357.55;
    my %detector = init_det();
    my $mate  = "BONuSGas";

	#print "transfer $trans, rmin = $rmin, rmax = $rmax, phistart = $phistart, deltaPhi = $pspan\n";

    $detector{"name"} = "trans_volume_".$trans;
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "transfer volume ".$trans;
    $detector{"color"}       = "baf7fc";
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
	#$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
	#$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}

# make transfer volumes between three GEM foils (70-79 mm) - seam part
sub make_transfer_volume_seam
{
	my $trans = shift;
	my $transSeam_region = shift;

    my $rmin  = $gem_radius[$trans] + 0.1 + $gap; # 0.1 is the seam think
    my $rmax  = $gem_radius[$trans] + 3.0 - $gap;
    my $phistart = $seam_phi_start[$transSeam_region] + $gap;
    my $pspan = $seam_phi_end[$transSeam_region] - $gap;
    my %detector = init_det();
    my $mate  = "BONuSGas";

	#print "  transfer $trans part $transSeam_region, rmin = $rmin, rmax = $rmax, phistart = $phistart, deltaPhi = $pspan\n";

    $detector{"name"} = "trans_volume_".$trans."_seam".$transSeam_region;
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "transfer volume ".$trans." seam part".$transSeam_region;
    $detector{"color"}       = "baf7fc";
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
	#$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
	#$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}

# readout pad layer
sub make_readout_layer
{
    my $rmin  = $pad_layer_radius;
    my $rmax  = $pad_layer_radius+$pad_layer_thick;
    my $phistart = 1;
    my $pspan = 358;
    my $zmax_half = $z_half+8.0;
    my %detector = init_det();
    my $mate  = "PCB";
        
    $detector{"name"} = "pad_layer";
        
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "Readout pad layer";
    $detector{"color"}       = $pad_layer_color[0];
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $zmax_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}

# seam in readout pad 2 degrees in phi
sub make_readout_seam
{
    my $region = shift;
    my $rmin  = $pad_layer_radius;
    my $rmax  = $pad_layer_radius+$pad_layer_thick;
    my $phistart = $pad_seam_phi_start[$region];
    my $pspan    = $pad_seam_phi_end[$region] - $gap;
    my $zmax_half = $z_half+8.0;
    my %detector = init_det();
    my $mate  = "PCB";
        
    $detector{"name"} = "pad_seam".$region;
        
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "Readout pad seam".$region;
    $detector{"color"}       = "330011";
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $zmax_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    print_det(\%configuration, \%detector);
}

# ERS layer - meant to simulate a smearing of material
# from readout pads to translation boards
sub make_ers_layer
{
    my $rmin  = $ers_layer_radius;
    my $rmax  = $ers_layer_radius+$ers_layer_thick;
    my $phistart = 0;
    my $pspan = 360;
    my %detector = init_det();
    my $mate  = "ERS";
        
    $detector{"name"} = "ers_layer";
        
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "Electronics/Ribs/Spine layer";
    $detector{"color"}       = $ers_layer_color[0];
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}

# translation boards
sub make_boards
{
    my $boardN = shift;
        
    my $rmin  = $Tboard_radius;
    my $rmax  = $Tboard_radius + $Tboard_length;
    my $pspan = ($Tboard_thick/(2*3.14*$Tboard_radius))*360;
    my $color = $Tboard_color[0];
    my $mate  = "PCB";
    my $phistart = $boardN*8;
    my %detector = init_det();
        
    $detector{"name"} = "board_".$boardN;
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "board_".$boardN;
    $detector{"color"}       = $color;
    $detector{"type"}        = "Tube";
    $detector{"style"}       = 1;
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}

# protection circuits on translation boards
sub make_protcircuit
{
    my $cirN = shift;
        
    my $rmin  = $prot_radius;
    my $rmax  = $prot_radius + $prot_length;
    my $pspan = ($prot_thick/(2*3.14*$prot_radius))*360;
    my $color = $prot_color[0];
    my $mate  = "protectionCircuit";
    my $phistart = ($Tboard_thick/(2*3.14*$Tboard_radius))*360 + $cirN*8;
    my %detector = init_det();
        
    $detector{"name"} = "cir_".$cirN;
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "cir_".$cirN;
    $detector{"color"}       = $color;
    $detector{"type"}        = "Tube";
    $detector{"style"}       = 1;
    $detector{"pos"}         = "0*mm 0*mm $z_shift*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}

# Down Stream End Plates (DSEP)
sub make_dsep
{
    # layer
    # 1 Target support block
    # 2 Cathode assembly inner ring
    # 3 DS plate
        
    my $dsepL = shift;
        
    my $dsep_zpos = $zhalf[1] + $dsep_zloc[$dsepL] + $z_shift + $gap;
    my $rmin  = $dsep_rmin[$dsepL];
    my $rmax  = $dsep_rmax[$dsepL];
    my $phistart = 0;
    my $pspan = 360;
    my %detector = init_det();
    my $mate  = $dsep_mat[$dsepL];
    my $dsepThick = $dsep_thick[$dsepL]/2.0;
    my $dsepColor = $dsep_color[$dsepL];
        
    $detector{"name"} = "dsep_".$dsepL;
        
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "Down Stream End Plate Layer ".$dsepL;
    $detector{"color"}       = $dsepColor;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $dsep_zpos*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $dsepThick*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}

# Up Stream End-plate
sub make_usep
{
    my $usep_zpos = $usep_zloc + $z_shift + $gap;
    my $rmin  = $usep_radius[0];
    my $rmax  = $usep_radius[1];
    my $phistart = 0;
    my $pspan = 360;
    my %detector = init_det();
    my $mate  = $usep_mat[0];
    my $usepThick = $usep_thick/2.0;
    my $usepColor = $usep_color[0];
        
    $detector{"name"} = "usep";
        
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "Up Stream End Plate Layer";
    $detector{"color"}       = $usepColor;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $usep_zpos*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $usepThick*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}

# RTPC to FT Snout
sub make_snout
{
    # 1 = Helium around target end cap
    # 2 = Helium from end cap to snout end
    # 3 = Snout wall
        
    my $snoutN = shift;
        
    my $snout_zpos = $snout_zloc[$snoutN]+$z_shift;
    my $rmin  = $snout_rmin[$snoutN];
    my $rmax  = $snout_rmax[$snoutN];
    my $phistart = 0;
    my $pspan = 360;
    my %detector = init_det();
    my $mate  = $snout_mat[$snoutN];
    my $snoutThick = $snout_thick[$snoutN]/2.0;
    my $snoutColor = $snout_color[$snoutN];
        
    $detector{"name"} = "snout_".$snoutN;
        
    $detector{"mother"}      = "rtpc";
    $detector{"description"} = "RTPC to FT buffer volume ".$snoutN;
    $detector{"color"}       = $snoutColor;
    $detector{"type"}        = "Tube";
    $detector{"pos"}         = "0*mm 0*mm $snout_zpos*mm";
    $detector{"dimensions"}  = "$rmin*mm $rmax*mm $snoutThick*mm $phistart*deg $pspan*deg";
    $detector{"material"}    = $mate;
    $detector{"style"}       = 1;
    #$detector{"sensitivity"}  = "rtpc"; ## HitProcess definition
    #$detector{"hit_type"}     = "rtpc"; ## HitProcess definition
    print_det(\%configuration, \%detector);
}



#################################
sub build_rtpc
{
    
    make_rtpc();

	make_targetGas();

    for(my $l = 0; $l < 3; $l++)
    {
		make_layers($l);
    }

	make_buffer_volume();
	make_buffer2_volume();
	make_drift_volume();

	for(my $gem = 0; $gem < 3; $gem++)
	{
		for(my $r = 0; $r < 2; $r++)
		{
			make_gems_seam($gem,$r);
		}

		for(my $l = 0; $l < 3; $l++)
		{
			make_gems($gem,$l);
		}

		make_transfer_volume($gem);

		for(my $r = 0; $r < 2; $r++)
		{
			make_transfer_volume_seam($gem,$r);
		}
    }

	make_readout_layer();

    for(my $r = 0; $r < 2; $r++)
    {
		make_readout_seam($r);
    }
     
	make_ers_layer();

    for(my $board = 0; $board < 45; $board++){
		make_boards($board);
    }

    for(my $circuit = 0; $circuit < 45; $circuit++){
		make_protcircuit($circuit);
    }

    for(my $dsep_layer = 0; $dsep_layer < 10; $dsep_layer++){
		make_dsep($dsep_layer);
    }

	make_usep();

    for(my $ftb_layer = 0; $ftb_layer < 3; $ftb_layer++){
		make_snout($ftb_layer);
    }
}

