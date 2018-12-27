



program matMulProduct
   implicit none
   double complex, dimension(4,4) :: a,b,  c
   integer :: i, j, iter
    
   do i = 1, 4
      do j = 1, 4
         a(i, j) = COMPLEX(0.045,0.021)
      end do
   end do
   do i = 1, 4
      do j = 1, 4
         b(i, j) = COMPLEX(0.085,0.051)
      end do
   end do
   



Print*, 'Matrix Multiplication: Result Matrix'
   c= matmul(a,b)
   call print_mat(c,4,4)
Print*, 'Custom function'
   a = mymatmul(a,b)
call print_mat(a,4,4)

contains

  subroutine print_mat(mat,i,j)
        integer , intent(in) :: i,j
        double complex, dimension(i,j), intent(in) :: mat       
        integer :: idx,jdx
        do idx = 1, i
                do jdx = 1, j
                Print*, mat(idx, jdx) 
                end do
        end do
 end subroutine

 function Mymatmul(a,b)
        integer :: j,i,n,k
        double complex :: tmp
        double complex,dimension(:,:) :: a,b
        double complex, dimension(size(a,1),size(a,1)) :: mymatmul
        n  = size(a,1)

     do j=1,n
         do i=1,n
            tmp = 0.0  ! enables ACC parallelism for k-loop
            do k=1,n
               tmp = tmp + a(i,k) * b(k,j)
            enddo
            mymatmul(i,j) = tmp
         enddo
      enddo
 end function



 end program 
