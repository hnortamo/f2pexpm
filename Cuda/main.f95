
program testprog
        use gpuexpm
        integer :: i,j,k
        integer, parameter :: N=10000
        double complex,dimension(4,4,N) :: mat_list
        double complex,dimension(size(mat_list,1),size(mat_list,2),size(mat_list,3)) :: cuexpm 
        do k = 1,N
        do i = 1, 4
                do j = 1, 4
                 mat_list(i, j,k) = CMPLX(0.045,0.021)
                end do
        end do
        end do
        print *, 'Calling kernel'
        do i = 1, 100
        call cudaexpm(mat_list,cuexpm)
        end do
        print *, 'Done'

        call print_mat(cuexpm(:,:,1),4,4)
        print *,'Last matrix' 
        call print_mat(cuexpm(:,:,N),4,4)
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
end program
