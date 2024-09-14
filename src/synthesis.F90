!C---------------------------------------------------------------------        
MODULE synthesis
!C----------------------------------------------------------------------
! ADCIRC - The ADvanced CIRCulation model
! Copyright (C) 1994-2023 R.A. Luettich, Jr., J.J. Westerink
! 
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU Lesser General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
! 
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
! 
! You should have received a copy of the GNU Lesser General Public License
! along with this program.  If not, see <http://www.gnu.org/licenses/>.
!
!-------------------------------------------------------------------------------!
!C**********************************************************************
!C Used for Baroclinic Current Synthesis 
!  Reads fort.54.nc from a previous run and extracts relevant info

!C   WRITTEN BY AMAN TEJASWI (10th SEP 2024)                
!C***********************************************************************
      

     CONTAINS  

       SUBROUTINE ReadUVSynthesisNC(F_NAME,CON_NAME,CONID)
               
#ifdef ADCNETCDF              
       USE NETCDF   
#endif     
       USE GLOBAL, ONLY: U_AMP_GL2LOC, V_AMP_GL2LOC,U_PHS_GL2LOC, V_PHS_GL2LOC
       USE MESSENGER, ONLY : MYPROC  
       IMPLICIT NONE

       REAL(8), DIMENSION(:), ALLOCATABLE :: U_AMP
       REAL(8), DIMENSION(:), ALLOCATABLE :: V_AMP
       REAL(8), DIMENSION(:), ALLOCATABLE :: U_PHS
       REAL(8), DIMENSION(:), ALLOCATABLE :: V_PHS
       REAL(8), ALLOCATABLE :: FFT(:), FACET(:)
       CHARACTER(10), INTENT(IN) :: CON_NAME
       CHARACTER(10), DIMENSION(:), ALLOCATABLE :: CONST
       CHARACTER(10) :: tempname
       
       CHARACTER(20),INTENT(IN) :: F_NAME
       INTEGER, INTENT(OUT) :: CONID
       INTEGER :: NODEID, LEN_CONST, LEN_NODE, CONST_ID
       INTEGER :: NCID, VARID, RETVAL, I

       !INTEGER, INTENT(IN) :: TimeStep
       

      

       retval = nf90_open(F_NAME, NF90_NOWRITE, ncid)
       if (retval /= nf90_noerr) then
         print *, "Error opening file:", trim(nf90_strerror(retval))
         stop
       end if
       
       retval =  nf90_inq_dimid(ncid, "num_const", CONST_ID)
       retval =  nf90_inq_dimid(ncid, "node", NODEID)

       retval = nf90_inquire_dimension(ncid, CONST_ID, len= LEN_CONST)
       retval = nf90_inquire_dimension(ncid, NODEID, len= LEN_NODE)
       

          ! Print the dimension lengths
       ! print *, "Number of constituents:", LEN_CONST
       ! print *, "Number of nodal values:", LEN_NODE

       ALLOCATE(U_AMP(LEN_NODE),V_AMP(LEN_NODE))
       ALLOCATE(U_PHS(LEN_NODE),V_PHS(LEN_NODE))
       ALLOCATE(CONST(LEN_CONST))
       ALLOCATE(FFT(LEN_CONST), FACET(LEN_CONST))
        
       retval = nf90_inq_varid(ncid, 'const', varid)
       if (retval /= nf90_noerr) then
        print *, "Error getting variable ID for const:", trim(nf90_strerror(retval))
        stop
       end if  

       retval = nf90_get_var(ncid, varid, CONST) 
       if (retval /= nf90_noerr) then
         print *, "Error reading const data:", trim(nf90_strerror(retval))
         stop
       end if


       do i = 1,LEN_CONST
            tempname = CONST(I)
            IF(TRIM(tempname) == TRIM(CON_NAME)) THEN
                 CONID = I
            ENDIF   
       end do

       !print *, 'CONID:', CONID

       retval = nf90_inq_varid(ncid, 'u_amp', varid)
       if (retval /= nf90_noerr) then
        print *, "Error getting variable ID for u_amp:", trim(nf90_strerror(retval))
        stop
       end if 

       retval = nf90_get_var(ncid, varid, U_AMP, start = [CONID, 1],& 
                count = [1, LEN_NODE]) 

       if (retval /= nf90_noerr) then
         print *, "Error reading u_amp data:", trim(nf90_strerror(retval))
         stop
       end if

      
        retval = nf90_inq_varid(ncid, 'v_amp', varid)
       if (retval /= nf90_noerr) then
        print *, "Error getting variable ID for v_amp:", trim(nf90_strerror(retval))
        stop
       end if 

       retval = nf90_get_var(ncid, varid, V_AMP, start = [CONID, 1],& 
                count = [1, LEN_NODE]) 

       if (retval /= nf90_noerr) then
         print *, "Error reading v_amp data:", trim(nf90_strerror(retval))
         stop
       end if  



       retval = nf90_inq_varid(ncid, 'u_phs', varid)
       if (retval /= nf90_noerr) then
        print *, "Error getting variable ID for u_phs:", trim(nf90_strerror(retval))
        stop
       end if 

       retval = nf90_get_var(ncid, varid, U_PHS, start = [CONID, 1],& 
                count = [1, LEN_NODE]) 

       if (retval /= nf90_noerr) then
         print *, "Error reading u_phs data:", trim(nf90_strerror(retval))
         stop
       end if

       retval = nf90_inq_varid(ncid, 'v_phs', varid)
       if (retval /= nf90_noerr) then
        print *, "Error getting variable ID for v_phs:", trim(nf90_strerror(retval))
        stop
       end if 

       retval = nf90_get_var(ncid, varid, V_PHS, start = [CONID, 1],& 
                count = [1, LEN_NODE]) 

       if (retval /= nf90_noerr) then
         print *, "Error reading v_phs data:", trim(nf90_strerror(retval))
         stop
       end if


       retval = nf90_inq_varid(ncid, 'nodal_factor', varid)
       if (retval /= nf90_noerr) then
        print *, "Error getting variable ID for nodal_factor:", trim(nf90_strerror(retval))
        stop
       end if 

       retval = nf90_get_var(ncid, varid, FFT) 

       if (retval /= nf90_noerr) then
         print *, "Error reading FFT data:", trim(nf90_strerror(retval))
         stop
       end if

       retval = nf90_inq_varid(ncid, 'equilibrium_argument', varid)
       if (retval /= nf90_noerr) then
        print *, "Error getting variable ID for equi argument:", trim(nf90_strerror(retval))
        stop
       end if 

       retval = nf90_get_var(ncid, varid, FACET) 

       if (retval /= nf90_noerr) then
         print *, "Error reading FACET data:", trim(nf90_strerror(retval))
         stop
       end if

       
       CALL MAP_UV_LOCAL(U_AMP, V_AMP, U_PHS, V_PHS, U_AMP_GL2LOC, V_AMP_GL2LOC, U_PHS_GL2LOC, V_PHS_GL2LOC)
      
         !IF(MYPROC.EQ.0) THEN
          !        print *, " I have crossed calling map_uv_local"
          !ENDIF 

      END SUBROUTINE ReadUVSynthesisNC   



!---------------------------------------------------------------------------------------
!  MAP THE GLOBAL VARIABLES U_AMP, V_AMP, U_PHS, V_PHS to U_AMP_GL2LOC, V_AMP_GL2LOC,
!  U_PHS_GL2LOC, V_PHS_Gl2LOC Using the MAPToLOCAL_REAL Subroutine 
!---------------------------------------------------------------------------------------

     SUBROUTINE MAP_UV_LOCAL(U_AMP, V_AMP, U_PHS, V_PHS, U_AMP_GL2LOC, V_AMP_GL2LOC, U_PHS_GL2LOC, V_PHS_GL2LOC)

     USE GL2LOC_MAPPING, ONLY: MAPTOLOCAL_REAL
     USE MESSENGER, ONLY : MYPROC 
     IMPLICIT NONE

     REAL(8), INTENT(IN) :: U_AMP(:), V_AMP(:), U_PHS(:), V_PHS(:)
     REAL(8), INTENT(OUT) :: U_AMP_GL2LOC(:), V_AMP_GL2LOC(:), U_PHS_GL2LOC(:), V_PHS_GL2LOC(:)
       
          !IF(MYPROC.EQ.0) THEN
          !        print *, " I am in MAP_UV_LOCAL"
          !ENDIF 

     CALL MAPTOLOCAL_REAL(U_AMP, U_AMP_GL2LOC)
     CALL MAPTOLOCAL_REAL(V_AMP, V_AMP_GL2LOC)
     CALL MAPTOLOCAL_REAL(U_PHS, U_PHS_GL2LOC)
     CALL MAPTOLOCAL_REAL(V_PHS, V_PHS_GL2LOC)


     END SUBROUTINE MAP_UV_LOCAL

!----------------------------------------------------------------------------------------
! START PROCESSING THE UV Fourier Synthesis and pass it to U_Tidal_Syn, V_Tidal_Syn
!----------------------------------------------------------------------------------------

      SUBROUTINE PROCESS_UVTidalSynthesis(U_Syn,V_Syn,TimeStep)
         
      USE GL2LOC_MAPPING, ONLY : MAPTOLOCAL_REAL
      USE GLOBAL, ONLY : DTDP, U_AMP_GL2LOC, V_AMP_GL2LOC,U_PHS_GL2LOC, V_PHS_GL2LOC,&
                        FFT,FACET
      USE MESH, ONLY : NP
      USE MESSENGER, ONLY : MYPROC 
      USE ADC_CONSTANTS, ONLY : deg2rad
      IMPLICIT NONE

      REAL(8), INTENT(OUT) :: U_Syn(:), V_Syn(:)
      REAL(8),DIMENSION(8) :: OMEGA_CONST
      INTEGER :: TimeStep, K, J
      CHARACTER(10), DIMENSION(8) :: CONST8_NAME 
      CHARACTER(20) :: FNAME = 'synthesis.nc'
      INTEGER :: CONID
       
      !REAL(8),ALLOCATABLE :: U_AMP_GL2LOC(:), V_AMP_GL2LOC(:), U_PHS_GL2LOC(:), V_PHS_GL2LOC(:)

      CONST8_NAME = (/ 'M2','S2','Q1','O1','P1','K1','N2','K2' /)
      
      OMEGA_CONST = (/ 1.405189028e-04,1.454441043e-04,6.495854130e-05,&
             6.759774407e-05,7.252294576e-05,7.292115851e-05,1.378796998e-04,1.458423170e-04 /)  
      !ALLOCATE(U_Syn(NP), V_Syn(NP))
      
      
         IF(MYPROC.EQ.0) THEN
                  print *, " I am at Timestep:", TimeStep
          ENDIF 
      
       DO J = 1, NP
            U_Syn(J) = 0.d0
            V_Syn(J) = 0.d0
       END DO
      DO K = 1,8
          
           call ReadUVSynthesisNC(FNAME, CONST8_NAME(K), CONID)
          
          
          DO J = 1, NP
             ! -1 as one of the constituents is steady in fort.54.nc

             U_Syn(J) = U_Syn(J) + U_AMP_GL2LOC(J)*FFT(CONID-1)*COS((OMEGA_CONST(K))*TimeStep - U_PHS_GL2LOC(J) + FACET(CONID-1))
             V_Syn(J) = V_Syn(J) + V_AMP_GL2LOC(J)*FFT(CONID-1)*COS((OMEGA_CONST(K))*TimeStep - V_PHS_GL2LOC(J) + FACET(CONID-1))

          END DO
      END DO

      !DEALLOCATE(U_Syn, V_Syn)


      END SUBROUTINE PROCESS_UVTidalSynthesis



END MODULE SYNTHESIS 

