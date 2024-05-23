

MODULE TIDE_MODEL



!*******************************************************************************!
!               WRITTEN BY AMAN TEJASWI (2024 MAY)
!-------------------------------------------------------------------------------!

!-------------------------------------------------------------------------------!
!       THIS MODULE IS A COPY OF TIDE MODEL DRIVER FROM OTPS (OSU) & PARTS OF 
!                            U_TIDE/T_TIDE
!    
!-------------------------------------------------------------------------------!
!    ENSURES NODAL FACTOR & EQU. ARG. CORRECTION THROUGH THE SIM PERIOD !!
!    ORIGINALLY THE FORMULAS WERE DEDUCED RICHARD RAY, March 1999
!
!    THE MODULE HANDLES EVERYTHING ON ITS OWN BY UPDATING THE FACET, 
!    PERT, ETRF ARRAYS DEFINED IN GLOBAL. ALSO THE MODULE HAS CONSTANT
!    PHASE SPEEDS AND FREQUENCIES OF 53 DESCRIBED CONSTITUENTS.

!    FOR TESTING PURPOSE, ONLY 31 CONSTITUENTS HAVE BEEN INCLUDED BUT ONE CAN 
!   EASILY TURN ON THE LEFT OUT CONSTITUENTS FROM THE SET OF 53. EVERYTHING IS SET
!   ACCORDINGLY TO THE FOLLOWING ORDER...

!   ARRAYS HAVE BEEN DEFINED WITH INDEXES OF THESE CONSTIUENTS FROM THE SET OF 53 .

!-------------------------------------------------------------------------------!
!     c_data = { 'm2';  's2';  'k1';  'o1';
!           'n2';  'p1';  'k2';  'q1';
!          '2n2'; 'mu2'; 'nu2';  'l2';
!           't2';  'j1';  'm1'; 'oo1';
!         'rho1';  'mf';  'mm'; 'ssa';
!           'm4'; 'ms4'; 'mn4';  'm6';
!          'mk3'; 's6' ;'2sm2';'s1'; 
!          '2q1';  'm3'; 'sa'};
!*******************************************************************************!
!    NOTE : NOW THE FORT.15 DOESN'T NEED USER SPECIFIED CONSTITUENTS
!    THAT MEANS IT WILL NOT READ THE NODAL FACTORS OR EQ ARG FROM THE
!    CONTROL FILE. EVERTHING IS HANDLED FROM THE NAMELIST CALLED-- "CONTROL_TIDE"

!-------------------------------------------------------------------------------!
!      ADCIRC - The ADvanced CIRCulation model
! Copyright (C) 1994-2023 R.A. Luettich, Jr., J.J. Westerink
!
!-------------------------------------------------------------------------------! 
         !USE SIZES
         !USE GLOBAL, only: DEBUG, INFO, ECHO, WARNING, ERROR,
     !&   scratchMessage, logMessage, screenMessage, allMessage,
     !&   setMessageSource, openFileForRead, unsetMessageSource,         
     !USE DateTime
     IMPLICIT NONE    
     contains

        SUBROUTINE NODAL_ARG(TPK_tmd,AMIGT_tmd,ETRF_tmd,FFT_tmd,FACET_tmd,TIME)

        ! USE SIZES
!         USE GLOBAL, only :: FACET, ETRF, TPK, AMIGT, FFT 
        ! USE ADC_CONSTANTS
         USE DateTime_TMD
         IMPLICIT NONE
                
         REAL(8), PARAMETER :: PP = 282.94; ! solar perigee at epoch 2000
         REAL(8), PARAMETER :: PI = 3.1415926535897
         REAL(8), PARAMETER :: RAD = PI/180.D0
         INTEGER(8) :: HOUR
         REAL(8), INTENT(IN) :: TIME
         INTEGER(8) :: T1, T2
         INTEGER :: lenidx
        ! INTEGER, INTENT(IN) :: YEAR, MONTH, DAY, HR, MM, SS
         
        ! CHARACTER(LEN=8), DIMENSION(:) :: CID
         CHARACTER(LEN=10) :: NDFC

         REAL(8), DIMENSION(31) :: IDX  ! INDEX OF CONSTS CONSIDERED
         INTEGER :: NT1, NT
         INTEGER :: IC
         REAL(8), DIMENSION(:), ALLOCATABLE :: GARG, F, U
         REAL(8), DIMENSION(:), ALLOCATABLE :: PU, PF, G, EQUIARG
         
         REAL(8), ALLOCATABLE, INTENT(OUT) ::   FACET_tmd(:),ETRF_tmd(:), TPK_tmd(:), AMIGT_tmd(:), FFT_tmd(:)

         REAL(8) :: SINN, COSN, SIN2N, COS2N, SIN3N
         REAL(8) :: S, H, P, OMEGA 
         REAL(8) :: TEMP1, TEMP2, TMP1, TMP2
         
         !READ *, YEAR, MONTH, DAY, HR, MM, SS

         
         !CALL DATE_MJD(YEAR, MONTH, DAY, HR, MM, SS, TIME)
         !print *, "TIME:", TIME

         CALL ASTROL(TIME, S, H, P, OMEGA)
         
         !print *, "AFTERASTROL_TIME:", TIME
         !print *, "S, P, H, OMEGA:", S, P, H, OMEGA

         HOUR = (TIME - floor(TIME))*24.D0;
         t1 = 15.D0*hour;
         t2 = 30.D0*hour;

         !print *, "HOUR:", HOUR
         !print *, "T1:", T1

         !NT1 = SIZE(t1,1)
         !print *, "NT1:", NT1
         NT = 1 
         SINN = 0.D0
         COSN = 0.D0
         SIN2N = 0.D0
         COS2N = 0.D0
         SIN3N = 0.D0
         NDFC = 'NDFC.OUT'
         
         IDX = (/30,35,19,12,27,17,37,10,25,26,28,33,34, &
                 23,14,24,11,5,3,2,45,46,44,50,42,51,40, &
                 18,8,41,1/)    !See the comments in the start of the module to get the name of constituents
         lenidx = size(idx,1)

!   allocating arrays  
         ALLOCATE(GARG(53))
         ALLOCATE(F(53))
         ALLOCATE(U(53))
         ALLOCATE(FACET_tmd(31))
         ALLOCATE(ETRF_tmd(31))
         ALLOCATE(AMIGT_tmd(31))
         ALLOCATE(FFT_tmd(31))
         ALLOCATE(TPK_tmd(31))

         ALLOCATE(PU(31))
         ALLOCATE(PF(31))
         ALLOCATE(G(31))
         ALLOCATE(EQUIARG(31))
!   allocation done
        garg(1) = h - pp;                        ! Sa
        garg(2) = 2*h;                           ! Ssa
        garg(3) = s - p;                         ! Mm
        garg(4) = 2*s - 2*h;                     ! MSf
        garg(5) = 2*s;                           ! Mf
        garg(6) = 3*s - p;                       ! Mt
        garg(7) = t1 - 5*s + 3*h + p - 90;       ! alpha1
        garg(8) = t1 - 4*s + h + 2*p - 90;       ! 2Q1
        garg(9) = t1 - 4*s + 3*h - 90;           ! sigma1
        garg(10) = t1 - 3*s + h + p - 90;         ! q1
        garg(11) = t1 - 3*s + 3*h - p - 90;       ! rho1
        garg(12) = t1 - 2*s + h - 90;             ! o1
        garg(13) = t1 - 2*s + 3*h + 90;           ! tau1
        garg(14) = t1 - s + h + 90;               ! M1
        garg(15) = t1 - s + 3*h - p + 90;         ! chi1
        garg(16) = t1 - 2*h + pp - 90;            ! pi1
        garg(17) = t1 - h - 90;                   ! p1
        garg(18) = t1 + 90;                       ! s1
        garg(19) = t1 + h + 90;                   ! k1
        garg(20) = t1 + 2*h - pp + 90;            ! psi1
        garg(21) = t1 + 3*h + 90;                 ! phi1
        garg(22) = t1 + s - h + p + 90;           ! theta1
        garg(23) = t1 + s + h - p + 90;           ! J1
        garg(24) = t1 + 2*s + h + 90;             ! OO1
        garg(25) = t2 - 4*s + 2*h + 2*p;          ! 2N2
        garg(26) = t2 - 4*s + 4*h;                ! mu2
        garg(27) = t2 - 3*s + 2*h + p;            ! n2
        garg(28) = t2 - 3*s + 4*h - p;            ! nu2
        garg(29) = t2 - 2*s + h + pp;             ! M2a
        garg(30) = t2 - 2*s + 2*h;                ! M2
        garg(31) = t2 - 2*s + 3*h - pp;           ! M2b
        garg(32) = t2 - s + p + 180.;             ! lambda2
        garg(33) = t2 - s + 2*h - p + 180.;       ! L2
        garg(34) = t2 - h + pp;                   ! T2
        garg(35) = t2;                            ! S2
        garg(36) = t2 + h - pp + 180;             ! R2
        garg(37) = t2 + 2*h;                      ! K2
        garg(38) = t2 + s + 2*h - pp;             ! eta2
        garg(39) = t2 - 5*s + 4.0*h + p;          ! MNS2
        garg(40) = t2 + 2*s - 2*h;                ! 2SM2
        garg(41) = 1.5*garg(30);                 ! M3
        garg(42) = garg(19) + garg(30);         ! MK3
        garg(43) = 3*t1;                          ! S3
        garg(44) = garg(27) + garg(30);         ! MN4
        garg(45) = 2*garg(30);                   ! M4
        garg(46) = garg(30) + garg(35);         ! MS4
        garg(47) = garg(30) + garg(37);         ! MK4
        garg(48) = 4*t1;                          ! S4
        garg(49) = 5*t1;                          ! S5
        garg(50) = 3*garg(30);                   ! M6
        garg(51) = 3*t2;                          ! S6
        garg(52) = 7.0*t1;                        ! S7
        garg(53) = 4*t2;                          ! S8

!     determine nodal corrections f and u 
!     -----------------------------------
        sinn = sin(omega*rad);
        cosn = cos(omega*rad);
        sin2n = sin(2*omega*rad);
        cos2n = cos(2*omega*rad);
        sin3n = sin(3*omega*rad);


!     CALCULATIONS FOR F

        f(1) = 1;                                     ! Sa
        f(2) = 1;                                     ! Ssa
        f(3) = 1 - 0.130*cosn;                        ! Mm
        f(4) = 1;                                     ! MSf
        f(5) = 1.043 + 0.414*cosn;                    ! Mf
        f(6) = sqrt((1+.203*cosn+.040*cos2n)**2 + &
              (.203*sinn+.040*sin2n)**2);              ! Mt

        f(7) = 1;                                     ! alpha1
        f(8) = sqrt((1.+.188*cosn)**2+(.188*sinn)**2);! 2Q1

        f(9) = f(8);                                ! sigma1
        f(10) = f(8);                               ! q1
        f(11) = f(8);                               ! rho1
        f(12) = sqrt((1.0+0.189*cosn-0.0058*cos2n)**2 + &
                  (0.189*sinn-0.0058*sin2n)**2);       ! O1

        f(13) = 1;                                   ! tau1
   
        tmp1  = 1.36*cos(p*rad)+.267*cos((p-omega)*rad); ! Ray's
        tmp2  = 0.64*sin(p*rad)+.135*sin((p-omega)*rad);

        f(14) = sqrt(tmp1**2 + tmp2**2);                ! M1
        f(15) = sqrt((1.+.221*cosn)**2+(.221*sinn)**2); ! chi1

        f(16) = 1;                                    ! pi1
        f(17) = 1;                                    ! P1
        f(18) = 1;                                    ! S1
        f(19) = sqrt((1.+.1158*cosn-.0029*cos2n)**2 + &
                (.1554*sinn-.0029*sin2n)**2);          ! K1
        f(20) = 1;                                    ! psi1
        f(21) = 1;                                    ! phi1
        f(22) = 1;                                    ! theta1
        f(23) = sqrt((1.+.169*cosn)**2+(.227*sinn)**2); ! J1
        
        f(24) = sqrt((1.0+0.640*cosn+0.134*cos2n)**2 + & 
                (0.640*sinn+0.134*sin2n)**2 );          ! OO1

        f(25) = sqrt((1.-.03731*cosn+.00052*cos2n)**2 + &
                   (.03731*sinn-.00052*sin2n)**2);     ! 2N2
        f(26) = f(25);                                ! mu2
        f(27) = f(25);                                ! N2
        f(28) = f(25);                                ! nu2
        f(29) = 1;                                    ! M2a
        f(30) = f(25);                              ! M2
        f(31) = 1;                                    ! M2b
        f(32) = 1;                                    ! lambda2

        temp1 = 1.-0.25*cos(2*p*rad)-0.11*cos((2*p-omega)*rad)-0.04*cosn;
        temp2 = 0.25*sin(2*p*rad)+0.11*sin((2*p-omega)*rad)+ 0.04*sinn;

        f(33) = sqrt(temp1**2 + temp2**2);              ! L2
        f(34) = 1;                                    ! T2
        f(35) = 1;                                    ! S2
        f(36) = 1;                                    ! R2
        f(37) = sqrt((1.+.2852*cosn+.0324*cos2n)**2 + &
             (.3108*sinn+.0324*sin2n)**2);             ! K2
        f(38) = sqrt((1.+.436*cosn)**2+(.436*sinn)**2); ! eta2

        f(39) = f(30)**2;                            ! MNS2
        f(40) = f(30);                              ! 2SM2
        f(41) = 1;   ! wrong                          % M3
        f(42) = f(19)*f(30);                     ! MK3
        f(43) = 1;                                    ! S3
        f(44) = f(30)**2;                           ! MN4
        f(45) = f(44);                              ! M4
        f(46) = f(44);                              ! MS4
        f(47) = f(30)*f(37);                     ! MK4
        f(48) = 1;                                    ! S4
        f(49) = 1;                                    ! S5
        f(50) = f(30)**3;                           ! M6
        f(51) = 1;                                    ! S6
        f(52) = 1;                                    ! S7
        f(53) = 1;                                    ! S8

!   CALCULATIONS FOR U

        u(1) = 0;                                       ! Sa
        u(2) = 0;                                       ! Ssa
        u(3) = 0;                                       ! Mm
        u(4) = 0;                                       ! MSf
        u(5) = -23.7*sinn + 2.7*sin2n - 0.4*sin3n;      ! Mf
        u(6) = atan(-1*(.203*sinn+.040*sin2n)/ &
             (1+.203*cosn+.040*cos2n))/rad;               ! Mt
        u(7) = 0;                                       ! alpha1
        u(8) = atan(.189*sinn/(1.+.189*cosn))/rad;     ! 2Q1
        u(9) = u(8);                                  ! sigma1
        u(10) = u(8);                                  ! q1
        u(11) = u(8);                                  ! rho1
        u(12) = 10.8*sinn - 1.3*sin2n + 0.2*sin3n;       ! O1
        u(13) = 0;                                       ! tau1
        u(14) = atan2(tmp2,tmp1)/rad;                    ! M1
        u(15) = atan(-1*.221*sinn/(1.+.221*cosn))/rad;    ! chi1
        u(16) = 0;                                       ! pi1
        u(17) = 0;                                       ! P1
        u(18) = 0;                                       ! S1
        u(19) = atan((-1*.1554*sinn+.0029*sin2n)/ &
           (1.+.1158*cosn-.0029*cos2n))/rad;              ! K1
        u(20) = 0;                                       ! psi1
        u(21) = 0;                                       ! phi1
        u(22) = 0;                                       ! theta1
        u(23) = atan(-1*.227*sinn/(1.+.169*cosn))/rad;    ! J1
        u(24) = atan(-1*(.640*sinn+.134*sin2n)/ &
            (1.+.640*cosn+.134*cos2n))/rad;              ! OO1
        u(25) = atan((-1*.03731*sinn+.00052*sin2n)/ &
               (1.-.03731*cosn+.00052*cos2n))/rad;        ! 2N2
        u(26) = u(25);                                 ! mu2
        u(27) = u(25);                                 ! N2
        u(28) = u(25);                                 ! nu2
        u(29) = 0;                                       ! M2a
        u(30) = u(25);                                   ! M2
        u(31) = 0;                                       ! M2b
        u(32) = 0;                                       ! lambda2
        u(33) = atan(-temp2/temp1)/rad ;                ! L2
        u(34) = 0;                                       ! T2
        u(35) = 0;                                       ! S2
        u(36) = 0;                                       ! R2
        u(37) = atan(-1*(.3108*sinn+.0324*sin2n)/ &
             (1.+.2852*cosn+.0324*cos2n))/rad;            ! K2
        u(38) = atan(-1*.436*sinn/(1.+.436*cosn))/rad;    ! eta2
        u(39) = u(30)*2;                               ! MNS2
        u(40) = u(30);                                 ! 2SM2
        u(41) = 1.5d0*u(30);                           ! M3
        u(42) = u(30) + u(19);                       ! MK3
        u(43) = 0;                                       ! S3
        u(44) = u(30)*2;                               ! MN4
        u(45) = u(44);                                 ! M4
        u(46) = u(30);                                 ! MS4
        u(47) = u(30)+u(37);                         ! MK4
        u(48) = 0;                                       ! S4
        u(49) = 0;                                       ! S5
        u(50) = u(30)*3;                               ! M6
        u(51) = 0;                                       ! S6
        u(52) = 0;                                       ! S7
        u(53) = 0;                                       ! S8





!----------------------------------------------------------------
!               AMPLITUDE, FREQUENCIES AND ETRF OF 31 CONST
!----------------------------------------------------------------
       ! ETRF: earthtide reduction factor
        ETRF_tmd = (/0.693,0.693,0.736,0.695, &
              0.693,0.706,0.693,0.695, &
              0.693,0.693,0.693,0.693, &
              0.693,0.695,0.695,0.695, &
              0.695,0.693,0.693,0.693, &
              0.693,0.693,0.693,0.693, &
              0.693,0.693,0.693, &
              0.693,0.693,0.802, &
              0.693/)

       ! AMIGT: frequencies of the considered constituents in the same order
        AMIGT_tmd = (/1.405189e-04,1.454441e-04,7.292117e-05,6.759774e-05, &
              1.378797e-04,7.252295e-05,1.458423e-04,6.495854e-05, &
              1.352405e-04,1.355937e-04,1.382329e-04,1.431581e-04, &
              1.452450e-04,7.556036e-05,7.028195e-05,7.824458e-05, &
              6.531174e-05,0.053234e-04,0.026392e-04,0.003982e-04, &
              2.810377e-04,2.859630e-04,2.783984e-04,4.215566e-04, &
              2.134402e-04,4.363323e-04,1.503693e-04, &
              7.2722e-05,0.6231934E-04,2.107783523e-04, & 
              1.990968403205456e-07/)

       ! TPK: amplitude of the considered consituents in the same order
         TPK_tmd = (/0.2441,0.112743,0.141565,0.100661, &
          0.046397,0.046848,0.030684,0.019273, &
          0.006141,0.007408,0.008811,0.006931, &
          0.006608,0.007915,0.007915,0.004338, &
          0.003661,0.042041,0.022191,0.019567, &
          0.00,0.00,0.00,0.00,0.00,0.00, &
          0.00,7.6464e-04,0.002565,0.003192,0.0031/)

! OUTPUT VARIABLES

        DO IC=1, lenidx

           PU(IC) = U(IDX(IC))*RAD
           PF(IC) = F(IDX(IC));
           G(IC)  = GARG(IDX(IC));

           EQUIARG(IC) = modulo(G(IC) + (PU(IC))/RAD,360.D0);

           FACET_tmd(IC) = EQUIARG(IC)
           FFT_tmd(IC) = PF(IC) 
        END DO
               
        
       !OPEN( unit = 141, file = NDFC, action = "write" ) ;

       !WRITE( 141, *) 'PU: ' , PU(:,1)

       !DO IC= 1, lenidx
       !WRITE( 141, *)  TPK(IC),AMIGT(IC),ETRF(IC),FFT(IC), FACET(IC)
       !ENDDO 

       !CLOSE(141)

END SUBROUTINE NODAL_ARG

SUBROUTINE ASTROL(TIME, S, H, P, N)

        USE DateTime_TMD
        IMPLICIT NONE

        REAL(8) :: CIRCLE, T
        REAL(8), INTENT(OUT) :: S, H, P, N
        REAL(8), INTENT(IN) :: TIME

        CIRCLE = 360.D0;
        T = TIME - 51544.4993;
        ! mean longitude of moon
! ----------------------
        s = 218.3164 + 13.17639648 * T;
        ! mean longitude of sun
! ---------------------
        h = 280.4661 +  0.98564736 * T;
        ! mean longitude of lunar perigee
! -------------------------------
        p =  83.3535 +  0.11140353 * T;
        ! mean longitude of ascending lunar node
! --------------------------------------
        N = 125.0445D0 -  0.05295377D0 * T;
!
        S = MODULO(S,circle);
        H = MODULO(H,circle);
        P = MODULO(P,circle);
        N = MODULO(N,circle);

        IF (s.LT.0) THEN 
         s = s + circle; 
         ENDIF

        IF (h.LT.0) THEN
         h = h + circle;
        ENDIF

        IF( p.LT.0) THEN 
           p = p + circle; 
        ENDIF
        
        IF( N.LT.0) THEN
           N = N + circle; 
        ENDIF

     RETURN
END SUBROUTINE ASTROL
       
SUBROUTINE DATE_MJD(year,month,day,hour,mm,ss,MJD)
         
         USE DateTime_TMD
         
         IMPLICIT NONE
          
         REAL(8) :: MJD0, D0, d
         INTEGER :: I
        
         REAL(8), INTENT(OUT) :: MJD
         INTEGER, INTENT(IN) :: YEAR, MONTH, DAY, HOUR, MM, SS
         
         INTEGER :: yearloc, monthloc, dayloc, hourloc, mmloc, ssloc
         REAL(8), DIMENSION(12) :: dpm
         mjd0 = 48622.D0;
         CALL datenum(d0,1992,1,1,0,0,0)      
         
         monthloc = month
         yearloc = year
         dayloc = day
         hourloc = hour
         mmloc = mm
         ssloc = ss
        
        dpm = (/31,28,31,30,31,30,31,31,30,31,30,31/)

        IF ((mod(yearloc,4) == 0).and.((mod(yearloc, 100) /= 0) .or. (mod(yearloc, 400) == 0))) THEN 
         dpm(2) = dpm(2)+1
        END IF

        CALL datenum(d,yearloc,monthloc,dayloc,hourloc,mmloc,ssloc);
        
        mjd = mjd0+d-d0;
        
        RETURN
END SUBROUTINE DATE_MJD


END MODULE TIDE_MODEL






