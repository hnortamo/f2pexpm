module gpuexpm
  IMPLICIT NONE
contains


! A list of N MxM matrices list_dim = \(M,M,N\)
attributes(global) function BatchExp(mat_list,num_threads)
                        integer, dimension(3) :: list_dim
                        integer :: num_threads
                        double complex , dimension(:,:,:) :: mat_list
                        double complex , dimension(size(mat_list,1),size(mat_list,2),size(mat_list,3)) :: BatchExp
                   end function

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

            attributes(device) function MyMatmul(a,b)
                        double complex,dimension(:,:) :: a,b
                        double complex,dimension(size(a,1),size(a,2)) :: MyMatmul
                        integer :: i,k,j,n
                        n= size(a,1)
                        do i=1,n
                                do j=1,n
                                        do k=1,n
                                                MyMatmul(i,j)=MyMatmul(i,j)+A(i,k)*B(k,j)
                                        end do
                                end do
                        end do
                end function

end module gpuexpm


