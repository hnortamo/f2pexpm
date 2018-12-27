module gpuexpm
  use cudafor
  IMPLICIT NONE
contains


subroutine cudaexpm(mat_list_in,mat_list_out)
        
        double complex , dimension(:,:,:),intent(in) :: mat_list_in
        double complex, dimension(:,:,:),intent(out) :: mat_list_out
        
        double complex, device,dimension(size(mat_list_in,1),size(mat_list_in,2),size(mat_list_in,3)) :: mat_dev_in,mat_dev_out
        type(dim3) :: grid, tBlock
        integer :: N
        N= size(mat_list_in,3)
        tBlock = dim3(1024,1,1)
        grid = dim3(ceiling(real(N)/tBlock%x),1,1)
	mat_dev_in=mat_list_in
        call BatchExp<<<grid, tBlock>>>(mat_dev_in, mat_dev_out)
	mat_list_out =mat_dev_out
        end subroutine 



! A list of N MxM matrices list_dim = \(M,M,N\)
! Check indexes
attributes(global) subroutine BatchExp(mat_list_in,mat_list_out)
                        integer :: i,n
                        double complex , dimension(:,:,:),intent(in) :: mat_list_in
                        double complex, dimension(:,:,:),intent(out) :: mat_list_out
                        n = size(mat_list_in,3)


                        i = blockDim%x * (blockIdx%x - 1) + threadIdx%x
                        if (i <= n) call expm(mat_list_in(:,:,i),mat_list_out(:,:,i),15) 

                    end subroutine

attributes(device) subroutine expm(mat,mat_out,num_terms)
        integer , intent(in) :: num_terms
        double complex, dimension(:,:), intent(in) :: mat 

! Precalculated table for inverse factorial
        DOUBLE PRECISION,parameter :: fact(21) = [ &
1.0                    ,&
1.0                    ,&
0.5                    ,&
0.16666666666666666    ,&
0.041666666666666664   ,&
0.008333333333333333   ,&
0.001388888888888889   ,&
0.0001984126984126984  ,&
2.48015873015873e-05   ,&
2.7557319223985893e-06 ,&
2.755731922398589e-07  ,&
2.505210838544172e-08  ,&
2.08767569878681e-09   ,&
1.6059043836821613e-10 ,&
1.1470745597729725e-11 ,&
7.647163731819816e-13  ,&
4.779477332387385e-14  ,&
2.8114572543455206e-15 ,&
1.5619206968586225e-16 ,&
8.22063524662433e-18   ,&
4.110317623312165e-19  & 
]
        
        double complex, dimension(:,:),intent(inout) :: mat_out
        double complex, dimension(SIZE(mat,1),SIZE(mat,2)) :: prev
        integer :: i



        prev=0.0
        do i = 1,SIZE(mat,1)
                prev(i,i)=1
        end do
        mat_out=0

        mat_out = mat_out+prev
        
        do i = 2,num_terms
        prev = MyMatmul(prev,mat)
        mat_out=mat_out+prev*fact(i)
        end do
end subroutine  

attributes(device) function Mymatmul(a,b)
        integer :: j,i,n,k
        double complex :: tmp
        double complex,dimension(:,:) :: a,b
        double complex, dimension(size(a,1),size(a,1)) :: mymatmul
        n  = size(a,1)

     do j=1,n
         do i=1,n
            tmp = 0.0  
            do k=1,n
               tmp = tmp + a(i,k) * b(k,j)
            end do
            mymatmul(i,j) = tmp
         end do
      end do
 end function
end module gpuexpm


