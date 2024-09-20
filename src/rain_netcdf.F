!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!            M O D U L E   N E T C D F    R A I N
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!! ENABLES NETCDF CAPABILITY FOR GRIDDED PRECIPITATION !!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

C*******************WRITTEN BY AMAN TEJASWI************************
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
C*******THE FILE IS FORT.290.NC WHICH CONTAINS PRECIPITATION RATE IN
C**************************** KG M-2 S-1 *******************************


C 
       MODULE NETCDF_RAIN
C 
       USE SIZES,ONLY : MYPROC

       USE GLOBAL, ONLY : ScreenUnit, setMessageSource, allMessage,
     &    screenMessage, logMessage, unsetMessageSource,
     &    DEBUG, ECHO, INFO, WARNING, ERROR, scratchMessage,CRAIN_TIMINC
         
#ifdef DATETIME
     &   ,basedatetime
#endif
#ifdef CMPI
       USE MESSENGER,ONLY : MSG_FINI
#endif
#ifdef DATETIME
       use datetime_module, only: datetime, timedelta
#endif

       IMPLICIT NONE
       
       
       logical :: fileEXT   
#ifdef DATETIME
       character(len=200) :: Precfile
       character(len=200) :: Precvar, Tmvar, LonGvar, Lativar
       character(len=200) :: Tmdim, LonGdim, Latidim, Tmformat
       
       real(8),allocatable :: weightsp(:,:,:) 
       integer,allocatable  :: indp(:,:,:)
       type(datetime) :: CurDT 
       integer :: ub, ubc ! size of weightsp and indp interpolant weights
       integer :: NT, NTC
#endif
       PUBLIC

C---------------------end of data declarations--------------------------------C

       CONTAINS


C***********************************************************************
C   SUBROUTINE NETCDFRAIN_INIT
C***********************************************************************
#ifdef DATETIME
      SUBROUTINE NETCDFRAIN_INIT()

      USE SIZES, ONLY : MYPROC, GBLINPUTDIR

      IMPLICIT NONE

      CurDT = basedatetime;
      NT = 0; NTC = 0; 

! Read meta info -------------------------------------------------
      
      Precfile = 'fort.290.nc'
      inquire(file=Precfile,exist=fileEXT)
      if (.not.fileEXT) then
            call allMessage(ERROR,
     &       'fort.290.nc precipitation file doesnt exist.')
            call PrecTerminate()
      endif


      inquire(file='fort.29',exist=fileEXT)
      if (.not.fileEXT) then
            call allMessage(ERROR,'fort.29 header file required to '//
     &                            'specify netcdf var names.')
            call PrecTerminate()
      else

            OPEN(29,FILE=TRIM(GBLINPUTDIR)//'/'//'fort.29',STATUS='OLD',
     &      ACTION='READ')

            !! Read netcdf dim/var names and datestr format from fort.29
               read(29,*) Tmdim    ! Time dimension name
               read(29,*) Tmvar    ! Time variable name
               read(29,*) Tmformat ! Format of time datestr
               read(29,*) LonGdim  ! Lon dimension name
               read(29,*) LonGvar  ! Lon var name
               read(29,*) Latidim  ! Lat dimension name
               read(29,*) Lativar  ! Lat var name
               read(29,*) Precvar  ! Precipitation var name
     
            CLOSE(29)
      endif
      

      end subroutine NETCDFRAIN_INIT
#endif
C***********************************************************************
C   SUBROUTINE NETCDFRAIN_GET
C***********************************************************************


      SUBROUTINE NETCDFRAIN_GET(PRECIP,NP)

      use mesh, only: SLAM, SFEA, bl_interp, bl_interp2
      use ADC_CONSTANTS, only: deg2rad, rad2deg
      use kdtree2_module, only: kdtree2, kdtree2_create
      implicit none

      integer :: NP
      real(8),intent(out) :: PRECIP(NP)

      integer :: i, ii, nxp, nyp, indt(4), NTkeep, xi, yi, cc
      real(8) :: RAIN1
      real,allocatable,dimension(:,:) :: Prec,lat,lon
      !real,allocatable,dimension(:,:) :: dum
      real(8), allocatable ::  lonv(:), latv(:), XY(:,:)
      real(8) :: xx, yy, wt(4) 
      logical :: regular_grid
      type(kdtree2), pointer :: tree
      !real(sz) :: WTIMINC

! Show the date in str_date format
      call logMessage(ECHO,'CurDT precipitation strng: '//
     &      CurDT%strftime("%Y-%m-%d %H:%M"))
! Compute the interpolating factors and indices on the first step
         ii=1;
         if (.not.allocated(indp)) then
             ub=1;ubc=1;
               if(ii.eq.1) then
                 call READNETCDFRAIN(Precfile,Precvar,lon,lat)
                 nxp = ubound(lon,1); nyp = ubound(lat,2)
               
               endif
         allocate(indp(ub,4,np),weightsp(ub,4,np))
      ! Make the interpolant weight
         if (ii.eq.1) then
               call READNETCDFRAIN(Precfile,Precvar,lon,lat)
         endif
        
            nxp = ubound(lon,1); nyp = ubound(lat,2)
           
           
            if (abs(lon(1,1) - lon(1,nyp)) < 1d-6) then
               regular_grid = .true. 
               allocate(lonv(nxp),latv(nyp))
              
               lonv = lon(:,1)
               latv = lat(1,:)
            else       
               regular_grid = .false. 
               ! Convert point matrices to 2 X (NXP*NYP) point vector
               allocate(XY(2,nxp*nyp))
              
               
               cc = 0
               do xi = 1,nxp
                  do yi = 1,nyp
                     cc = cc + 1
                     XY(1,cc) = lon(xi,yi)
                     XY(2,cc) = lat(xi,yi)
                  enddo
               enddo
               ! Create the search tree
               tree => kdtree2_create(XY)
              
            endif
          
!     Loop over each node and interpolate
            do i = 1,np
               xx = rad2deg*slam(i)
               ! Convert our numbers if grids are 0 to 360
               if (maxval(lon).gt.180d0.and.xx < 0d0) xx = xx + 360d0
               yy = rad2deg*sfea(i)
               if (regular_grid) then
                  call bl_interp(nxp,lonv,nyp,latv,xx,yy,indt,wt)
               else
                  call bl_interp2(nxp,nyp,lon,lat,xx,yy,indt,wt,tree)
               endif
               indp(ii,:,i) = indt
               weightsp(ii,:,i) = wt

            enddo
           

            if (regular_grid) then
               deallocate(lon,lat,latv,lonv)
            else
               deallocate(lon,lat,XY)
            endif
          !enddo
         endif
       

! Get the Precipitation data
!':PRATE_surface:mean sea level:'
       call READNETCDFRAIN(Precfile,Precvar,Prec)
     
! Add WTIMINC on CurDT for next WTIME  
       CurDT = CurDT + timedelta(minutes=floor(CRAIN_TIMINC/60d0))
      ! Next time index for the netcdf reading
       NT = NT + 1
     
         do i = 1,np
            !rain1=-9999.9D0
            if (indp(ubc,1,i) < 0) then
               PRECIP(i) = 0.d0;
            else
               PRECIP(i) = 
     &             Prec(indp(ubc,1,i),indp(ubc,2,i))*weightsp(ubc,1,i) +
     &             Prec(indp(ubc,3,i),indp(ubc,2,i))*weightsp(ubc,2,i) +
     &             Prec(indp(ubc,1,i),indp(ubc,4,i))*weightsp(ubc,3,i) +
     &             Prec(indp(ubc,3,i),indp(ubc,4,i))*weightsp(ubc,4,i)
            endif
            rain1 = PRECIP(i)*0.001d0
            PRECIP(i) = rain1
           
         enddo

         RETURN
      
         deallocate(Prec)
       
         NTC = NTC + 1
      

      end subroutine NETCDFRAIN_GET



!----------------------------------------------------------------------
!----------------------------------------------------------------------
!
!                  SUBROUTINE READ IN NETCDF FILE
!
!----------------------------------------------------------------------
!----------------------------------------------------------------------

      SUBROUTINE READNETCDFRAIN(fileN,var,data2,data22)
    
      
     
#ifdef ADCNETCDF
      use netcdf
#endif
      implicit none
      character(len=200),intent(in) :: var, fileN
      real,allocatable,intent(out) :: data2(:,:) 
      real,allocatable,intent(out),optional :: data22(:,:) 
      character(len=19),allocatable :: TimeStr(:) 
      character(len=200) :: str_date
      integer :: i, NC_ID, Temp_ID, Lat_ID, Lon_ID, NX, NY, TL, ndims
      if(present(data22)) then

! Read lon and lat
#ifdef ADCNETCDF
      call Check_err(NF90_OPEN(fileN,nf90_nowrite,NC_ID))
      call Check_err(NF90_INQ_DIMID(NC_ID,Latidim,Temp_ID))
      call Check_err(NF90_INQUIRE_DIMENSION(NC_ID,Temp_ID,len=NY))
      call Check_err(NF90_INQ_DIMID(NC_ID,LonGdim,Temp_ID))
      call Check_err(NF90_INQUIRE_DIMENSION(NC_ID,Temp_ID,len=NX))
      call Check_err(NF90_INQ_DIMID(NC_ID,Tmdim,Temp_ID))
      call Check_err(NF90_INQUIRE_DIMENSION(NC_ID,Temp_ID,len=TL))
       allocate(data2(NX,NY),TimeStr(TL))

       allocate(data22(NX,NY))

       if (NT.eq.0) then
               if (Tmformat(1:1).eq.'%') then
                  call Check_err(NF90_INQ_VARID(NC_ID,Tmvar,Temp_ID))
                  call Check_err(NF90_GET_VAR(NC_ID,Temp_ID,TimeStr))
                  ! Determine the first timestep index
                  str_date = CurDT%strftime(trim(Tmformat)) 
                  write(16,*) 'Precipitation Str_date: ',trim(str_date)
                  do NT = 1,TL
                     if (trim(str_date).eq.TimeStr(NT)) exit
                  enddo
                  call logMessage(ECHO,'Starting from '//TimeStr(NT))
               else
                  call logMessage(ECHO,'Assume to start from beginning')
                  NT = 1 
               endif
               !write(16,*) 'Prec Starting time indice = ',NT
               NTC = NT
       endif
            call Check_err(NF90_INQ_VARID(NC_ID,Lativar,Lat_ID))
            call Check_err(nf90_inquire_variable(NC_ID,Lat_ID,
     &                     ndims=ndims))
            call Check_err(NF90_INQ_VARID(NC_ID,LonGvar,Lon_ID))
            write(16,*) 'Lon/Lat dimensions = ',ndims
            if (ndims.eq.3) then
               call Check_err(NF90_GET_VAR(NC_ID,Lat_ID,data22,
     &                        start=[1, 1, NT],count=[NX, NY, 1]))
               call Check_err(NF90_GET_VAR(NC_ID,Lon_ID,data2,
     &                        start=[1, 1, NT],count=[NX, NY, 1]))
            elseif (ndims.eq.2) then
               call Check_err(NF90_GET_VAR(NC_ID,Lat_ID,data22))
               call Check_err(NF90_GET_VAR(NC_ID,Lon_ID,data2))
            else
               call Check_err(NF90_GET_VAR(NC_ID,Lat_ID,data22(1,:)))
               call Check_err(NF90_GET_VAR(NC_ID,Lon_ID,data2(:,1)))
               do i = 2,NX
                  data22(i,:) = data22(1,:)
               enddo
               !write(16,*) data22
               do i = 2,NY
                  data2(:,i) = data2(:,1)
               enddo
       
            endif
            call Check_err(NF90_CLOSE(NC_ID))
            
#endif
       else

            ! NETCDF
#ifdef ADCNETCDF

         call Check_err(NF90_OPEN(fileN,nf90_nowrite,NC_ID))
         call Check_err(NF90_INQ_DIMID(NC_ID,Latidim,Temp_ID))
         call Check_err(NF90_INQUIRE_DIMENSION(NC_ID,Temp_ID,len=NY))
         call Check_err(NF90_INQ_DIMID(NC_ID,LonGdim,Temp_ID))
         call Check_err(NF90_INQUIRE_DIMENSION(NC_ID,Temp_ID,len=NX))
!         if(allocated(data2)) deallocate(data2)
         allocate(data2(NX,NY))
         call Check_err(NF90_INQ_VARID(NC_ID,var,Temp_ID))
         call Check_err(NF90_GET_VAR(NC_ID,Temp_ID,data2,
     &                  start=[1, 1, NT],count=[NX, NY, 1]))
         call Check_err(NF90_CLOSE(NC_ID))
        ! write(16,*) data2
#endif
!          write(ScreenUnit,'("Passed READNETCDFRAIN")')
       endif
          end subroutine READNETCDFRAIN


C-----------------------------------------------------------------------
C     S U B R O U T I N E   V O L U M E _ C H E C K
C-----------------------------------------------------------------------

!!    checks the total volume of the element and saves it in totvol file
!!    this subroutine is just for the sake of understanding how much water 
!!    we are putting in.

        SUBROUTINE VOLUME_CHECK(TimeLoc)

        use sizes, only : localDir,MNPROC    
        USE GLOBAL, ONLY: IFNLFA, IFNLCT, NODECODE, NOFF, 
     &                  ETA2, IMAP_EL_LG, COMM
        USE MESH, ONLY: NE, NM, NP, DP, AREAS, NODELE, FDXE, FDYE,
     &      NEITABELE, NEITAB, NNEIGH, SFAC, SFCT,
     &      SFMXEle, SFMYEle
!        USE MPI
        
         IMPLICIT NONE 
         
         REAL(8) :: EtaN1, EtaN2, EtaN3
         INTEGER :: NEle           !local value of NetTabEle
         INTEGER :: NCEle          !element code
         INTEGER :: NM1,NM2,NM3    !local node numbers
         INTEGER :: NC1,NC2,NC3    !local node codes
         INTEGER :: IE             !element loop counter        
         REAL(8) :: AreaEle, AreaIE2      ! elemental area
         !REAL(SZ) :: EtaN1, EtaN2, EtaN3
         REAL(8) :: H1, H2, H3    !bathy of 3 nodes
         REAL, allocatable :: VolEle(:)      !volume of an element
         REAL*8,intent(in) :: TimeLoc     ! time in sec since cold start
         LOGICAL :: THERE   
         LOGICAL :: GHOST
         REAL(8) :: TotalVol, sumVol1
         INTEGER :: IERR
         INTEGER :: iterproc    !proc counter
         REAL(8) :: TotalAreaDom
         REAL*8 :: factor

            allocate(VolEle(NE))
            sumVol1= 0.0d0; 
            TotalAreaDom = 0.0d0
            IF (MNPROC.GT.1) then
                   INQUIRE(FILE=TRIM(LOCALDIR)//'/'//'vol.dat',EXIST=THERE)
                   IF(THERE) then
                       OPEN(99,FILE=TRIM(LOCALDIR)//'/'//'vol.dat',
     &         STATUS='OLD',POSITION='APPEND',ACTION='WRITE')
                    ELSE
                       OPEN(99,FILE=TRIM(LOCALDIR)//'/'//'vol.dat',
     &         STATUS='NEW',POSITION='APPEND',ACTION='WRITE')
                    ENDIF
            ENDIF        
            DO IE = 1,NE
               NM1 = NM(IE,1)
               NM2 = NM(IE,2)
               NM3 = NM(IE,3)
               NC1 = NODECODE(NM1)
               NC2 = NODECODE(NM2)
               NC3 = NODECODE(NM3)
               NCEle = NC1*NC2*NC3*NOFF(IE)
               EtaN1 = IFNLFA*Eta2(NM1)
               EtaN2 = IFNLFA*Eta2(NM2)
               EtaN3 = IFNLFA*Eta2(NM3)
               factor = (SFCT(NM(IE,1)) +SFCT( NM(IE,2)) +SFCT(NM(IE,3)))/3.0d0
               AreaIE2 = Areas(IE)
               AreaEle = 0.5d0*AreaIE2*factor
               H1 = DP(NM1)
               H2 = DP(NM2)
               H3 = DP(NM3)

               VolEle(IE) = ((H1 + EtaN1) + (H2 + EtaN2) + (H3 + EtaN3))*(AreaEle)/3.0d0

               IF(IMAP_EL_LG(IE).GT.0) THEN
                 sumVol1 = sumVol1 + VolEle(IE)
                      
               ELSE
                       continue
               ENDIF
               IF(NCEle.EQ.1) THEN
                  TotalAreaDom = TotalAreaDom + AreaEle;
               ELSE
                       continue
               ENDIF
                      
               
            END DO
              
              WRITE(99,*) 'TotalWetArea: ',TotalAreaDom  
              WRITE(99,*) 'SumVol: ',SumVol1 
               
              CLOSE(99)
                            
        !CALL MPI_Reduce(sumVol,TotalVol,1,MPI_FLOAT,MPI_SUM,0,COMM,ierr)
            deallocate(VolEle)
       ! WRITE(16,*) 'TotalVol: ', TotalVol
        END SUBROUTINE VOLUME_CHECK

      

C     S U B R O U T I N E   C H E C K  _  E R R
C-----------------------------------------------------------------------
      subroutine check_err(iret)
      USE SIZES, ONLY : myproc
      USE GLOBAL, ONLY : screenUnit
#ifdef CMPI
      USE MESSENGER, ONLY : MSG_FINI
#endif
      USE NETCDF
      IMPLICIT NONE

      INTEGER, intent(in) :: iret

      call setMessageSource("check_err")
#ifdef ALL_TRACE
      call allMessage(DEBUG,"Enter.")
#endif
      if (iret .ne. NF90_NOERR) then
         call allMessage(ERROR,nf90_strerror(iret))
         call PrecTerminate()
      endif
#ifdef ALL_TRACE
      call allMessage(DEBUG,"Return.")
#endif
      call unsetMessageSource()
C-----------------------------------------------------------------------
      end subroutine check_err

C----------------------------------------------------------------------
C...  Subroutine to terminate precipitation
C...
C----------------------------------------------------------------------
      SUBROUTINE PrecTerminate()
#ifdef CMPI
      USE MESSENGER, ONLY : MSG_FINI
#endif
      IMPLICIT NONE
C
      call setMessageSource("PrecTerminate")

      call allMessage(ERROR,"ADCIRC terminating.")
#ifdef CMPI
      call msg_fini()
#endif
      CALL EXIT(1)
C
      call unsetMessageSource()
      RETURN
      end subroutine PrecTerminate

      end MODULE NETCDF_RAIN
