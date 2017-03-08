! Conway's Game of Life implemented in FORTRAN 90
! Written by F.Jaume-Santero  --  Feb. 23rd, 2017

! Main program
program  main
	use netcdf
	use golmod
	implicit none

! Define the initial grid G and the final grid F
	integer, dimension(:,:), allocatable :: G,F

! Define counters & dimensions
	integer, parameter :: L = 10
	integer :: i,j,k,t,time

! Name of the netCDF file
	character(len = 6), parameter :: FILE_NAME = "gol.nc"
	integer, parameter :: NDIMS = 3

! Variables and dimensions of the netCDF file
	integer :: ncid, varid, dimids(NDIMS)
	integer :: x_dimid, y_dimid, t_dimid

! Define READ variables
	integer, dimension(2*L) :: line
	character(len = 6) :: FMT
	character(len = 14) :: filename
	write(FMT,'(A1,I2,A3)') '(',2*L,'I1)'

! Create netCDF file
	call check(nf90_create(FILE_NAME, NF90_CLOBBER, ncid))

! Define the dimensions. NetCDF will hand back an ID for each.
	call check(nf90_def_dim(ncid, "x", L, x_dimid))
	call check(nf90_def_dim(ncid, "y", L, y_dimid))
	call check(nf90_def_dim(ncid, "time", nf90_unlimited, t_dimid))

! Pass the IDs y_dimid, x_dimid. WARNING: Column-major format
	dimids =  (/ x_dimid, y_dimid, t_dimid /)

! Read initial condition G0 from 'gol00.csv' (It's a Glider!)
! Must have same dimension (LxL)
	allocate(G(L,L))
	allocate(F(L,L))
	open(10, file = 'data/gol00.csv')
		do i = 1,L
			read (10, FMT) line(:)
			j = 1
			do k = 1,2*L
				if (mod(k,2) == 1) then
					G(i,j) = line(k)
					j = j + 1
				end if
			end do
		end do
	close(10)

! Set number of timesteps
	t = 23

! Type of variable
	call check(nf90_def_var(ncid, "data", NF90_INT, dimids, varid))

! End define mode.
	call check(nf90_enddef(ncid))

! Load initial condition into the netCDF
	call check(nf90_put_var(ncid, varid, transpose(G), start=[1,1,1], count=[L,L,1]))

! Evolution of Conway's Game of Life
	do time = 1,t
		call gol(G, F, L)

! Select filename based on time
		write(filename,'("data/gol",I2.2,".csv")') time

! Open file 'goln.csv' to write G where n is the timestep 'time'
		open(20, file=filename)
		do i = 1,L
			do j = 1,L
				if (j .lt. L) then
					write(20, '(I1,A1)', advance='no') F(i,j), ','
				else
					write(20, '(I1,A1)', advance='no') F(i,j), char(10)
				end if
			end do
		end do
		close(20)

! Write F matrix in the netCDF file
	call check(nf90_put_var(ncid, varid, transpose(F), start=[1,1,time + 1], count=[L,L,1]))
	end do

! Close netCDF file
	call check(nf90_close(ncid))

! Deallocate G & F
	if (allocated (G)) deallocate (G)
	if (allocated (F)) deallocate (F)

! Check netCDF outputs for no errors
contains
	subroutine check(status)
		integer, intent(in) :: status
		if(status /= nf90_noerr) then
			print *, trim(nf90_strerror(status))
			stop 2
		end if
	end subroutine check

! End of the main program
end program main
