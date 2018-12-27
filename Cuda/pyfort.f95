
function cuexpm(mat_list)
        double complex,dimension(:,:,:) :: mat_list
        double complex,dimension(size(mat_list,1),size(mat_list,2),size(mat_list,3)) :: cuexpm
        call cudaexpm(mat_list,cuexpm)
end function
