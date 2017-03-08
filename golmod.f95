! Subroutine to implement Conway's Game of Life
! Written by F.Jaume-Santero  Feb 24th, 2017
module golmod
  implicit none
  contains

! Definition of gol() subroutine
    subroutine gol(Gt, Ft, L)
      integer :: total,i,j,k,L
      integer, dimension(L,L) :: Gt, Ft

! Setting the limits: F(i,j) = 0 at extreme points of the space
        do k = 1,L
          Ft(1,k) = 0
          Ft(L,k) = 0
          Ft(k,1) = 0
          Ft(k,L) = 0
        end do

! Implementing the rules for the rest of the square
        do i = 2,L-1
          do j = 2,L-1
            ! Sum of living neighbours for G(i,j)
            total = Gt(i-1,j-1) + Gt(i,j-1) + Gt(i+1,j-1) + Gt(i+1,j) &
                + Gt(i+1,j+1) + Gt(i,j+1) + Gt(i-1,j+1) + Gt(i-1,j)

            ! Rule 1: If G(i,j) = 1 & total < 2,     ->  F(i,j) = 0
            if ((Gt(i,j) == 1) .and. (total .lt. 2))        then
              Ft(i,j) = 0

            ! Rule 2: If G(i,j) = 1 & 2 < total < 3, ->  F(i,j) = 1
            else if ((Gt(i,j) == 1)  .and. &
                ((total .ge. 2) .and. (total .le. 3))) then
              Ft(i,j) = 1

            ! Rule 3: If G(i,j) = 1 & total > 3,     ->  F(i,j) = 0
            else if ((Gt(i,j) == 1) .and. (total .gt. 3))   then
              Ft(i,j) = 0

            ! Rule 4: If G(i,j) = 0 & total = 3,     ->  F(i,j) = 1
            else if ((Gt(i,j) == 0) .and. (total == 3))     then
              Ft(i,j) = 1

            ! The rest of options G(i,j) = 0         ->  F(i,j) = 0
            else
              Ft(i,j) = 0
            end if
          end do
        end do
        Gt = Ft
    end subroutine gol
end module golmod
