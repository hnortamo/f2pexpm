



program matMulProduct
   implicit none
   double complex, dimension(4,4) :: a,  c
   integer :: i, j, iter
    
   do i = 1, 4
      do j = 1, 4
         a(i, j) = COMPLEX(0.045,0.021)
      end do
   end do
    
   do iter =1,1000000 
   call expm(a,c)
   end do
   call print_mat(a,4,4) 
   call print_mat(c,4,4)


Print*, 'Matrix Multiplication: Result Matrix'

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

  
subroutine expm(mat,mat_out)
        double complex, dimension(:,:), intent(in) :: mat 
        real,parameter :: fact(21) = [ &
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
        
        
        prev=0.0
        prev(1,1)=1
        prev(2,2)=1
        prev(3,3)=1
        prev(4,4)=1
        mat_out=0

        mat_out = mat_out+prev
        
        do i = 2,11
        prev = matmul(prev,mat)
        mat_out=mat_out+prev*fact(i)
        end do
end subroutine  


 end program
