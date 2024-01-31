### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ 7a7a04c2-cb31-47fe-8598-075241d06a38
begin
	using PlutoUI # This is for sliders in case needed
	using Images
	using LinearAlgebra
end

# ╔═╡ fafae38e-e852-11ea-1208-732b4744e4c2
md"""_Homework 4, Fall 2023_\
_Release date: Friday, Dec. 01, 2023_\
**HW4 due date: Friday, Dec. 08, 2023, 17:00**"""

# ╔═╡ 7308bc54-e6cd-11ea-0eab-83f7535edf25
# edit the code below to set your name and KU ID (i.e. email without @ku.edu.tr)

student = (name = "Alp Kural", ku_id = "akural19")

# use Shift+Enter to run your edits


# ╔═╡ cdff6730-e785-11ea-2546-4969521b33a7
md"""

Submission by: **_$(student.name)_** ($(student.ku_id)@ku.edu.tr)
"""

# ╔═╡ 95d94d54-7229-4204-882b-45db699e421f
md"""# HW-4: Images and use of SVD

#### The aim of this homework is to learn how to 

#### $\quad - \;$ download images and assess its size in memory
#### $\quad - \;$ work on images
#### $\quad - \;$ how to compress images using matrix slicing 
#### $\quad - \;$ how to use SVD for compression 
\

#### Good luck 😄

---
"""

# ╔═╡ a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
md"""# Question - 1 (20pts)
### Download a colored image from the web (any you like)
#### $\quad - \;$ Learn which packages you need 
#### $\qquad \;\circ \;$ for downloading
#### $\qquad \;\circ \;$ for showing (use Plots and/or Mosaics)
#### $\quad - \;$ Compute its size in MB (MegaBites) 
#### $\quad - \;$ Compare the size on the disc
#### $\quad - \;$ Slice the colored image
#### $\qquad \qquad \;$ Hint: Use `channelview` and `permutedims` 
#### $\quad - \;$ Show the images side-by-side to compare the qualities
---
"""

# ╔═╡ 3638a9c6-5ce2-487e-b16a-84a025ede8c0
begin
	url = "https://i.pinimg.com/564x/25/ac/14/25ac14deae4aeb03878ace8441294d5e.jpg"
	image = download(url)
	image_var = load(image)
end;

# ╔═╡ 499b8010-e89d-4e73-b5bc-d6ed9fab4986
md"""
##### Size on the Disk = W x H x Color Depth 
Color Depth = 24 bits
"""

# ╔═╡ 08e0af6c-81a7-447e-b141-4265e5421706
begin
	matrix_form = channelview(image_var)
	size(matrix_form)
end

# ╔═╡ 747dea3b-1ea0-4fca-9b23-82db95a5179f
function sizeOnDisk(w, h, d)
	total_bits = w * h * d
	total_Mbs = round(total_bits / 10^6, digits = 3)
	total_MB = round((total_Mbs / 8), digits = 3)
	"$total_bits Bits, $total_Mbs Mbs (Megabits), $total_MB MB (MegaBytes)"
end;

# ╔═╡ 00c3c2d8-07ef-486f-af16-d2cc8611d7be
md"""
###### Size on the disk of the original image: 0.954 MB
"""

# ╔═╡ e04421c7-30ef-40e8-b382-b9351db5847a
sizeOnDisk(564, 564, 24)

# ╔═╡ 761cc39e-2713-40b5-bd9c-9b74a0853afd
begin
	sliced_image1 = imresize(image_var[1:4:564, 1:4:564], (564,564))
	sliced_image2 = imresize(image_var[1:6:564, 1:6:564], (564,564))
	sliced_image3 = imresize(image_var[1:8:564, 1:8:564], (564,564))
end;

# ╔═╡ 297ba9e1-c690-48e4-beba-08e1485b573c
md"
$$\begin{aligned}
&\begin{array}{ c  c  c c }
 \text {\bf \large Original}  & \qquad \qquad \text {\bf \large Step-4 } & \qquad \qquad \text { \bf \large Step-6 } & \qquad \qquad \text { \bf \large Step-8 } \\
\end{array}
\end{aligned}$$
"

# ╔═╡ 4423a8e5-8513-4c75-96a9-9cd1dd54e1c1
[image_var sliced_image1 sliced_image2 sliced_image3]

# ╔═╡ 427c24b5-c009-4338-9152-84957751d726
md"""# Question - 2 (40pts)
### $\color{red} \text{SVD for grayscale image}$
#### For the image you have downloaded and sliced in Part -1, 
#### $\qquad - \;$ Convert the orginal image to a grayscale image
#### $\qquad - \;$ Apply the SVD to the grayscale image
#### $\qquad - \;$ Compare the orginal image with different rank images
#### $\qquad - \;$ Compare the performance of SVD to the slicing
#### $\qquad \quad \;\circ \;$ memory allocations
#### $\qquad \quad \;\circ \;$ differences from the original (error)

---
"""

# ╔═╡ 84478d8a-6fc1-4239-a502-b1fff0d063c9
function approximator(matrix, bound)
	U,σ,V = svd(matrix, full = true)
	agg_matrix = σ[1] * U[:,1] * V[:,1]'
	for ii = 2:bound
		agg_matrix = agg_matrix + σ[ii] * U[:,ii] * V[:,ii]'
	end
	return agg_matrix
end

# ╔═╡ 63c6e61b-8ded-4d59-80c9-d959f2544efe
gray_image_var = Gray.(image_var);

# ╔═╡ f6837d47-e61b-4fa2-828e-908c91dff0b5
size(gray_image_var)

# ╔═╡ 5521e3db-70ff-4247-b65a-d9b4d8b3575c
matrix_gray = channelview(gray_image_var);

# ╔═╡ 3e4bcb44-685a-4bb4-a1f6-67584d3d790c
rank(matrix_gray)

# ╔═╡ 2c32db5e-ce4c-4671-9e54-2665a7dcfed8
begin
	full_rank_approx = approximator(matrix_gray, rank(matrix_gray));
	rank40_approx = approximator(matrix_gray, 40)
	rank20_approx = approximator(matrix_gray, 20)
end;

# ╔═╡ 93383358-dc44-4c6b-8a68-1e5c126af09f
md"""
###### U = (564, 392) σ = (392,) V = (564, 392) for Full Rank Approximation
"""

# ╔═╡ 2e827f88-4ec1-4c3a-bcb5-64d70716adda
md"""
###### Total size in the disk: 0.442 MB
"""

# ╔═╡ 096bb645-6c03-4842-8584-e9a9cd98567b
(sizeOnDisk(564, 392, 8))

# ╔═╡ f550b6f6-27f5-4fa6-a838-31ab983aa329
(sizeOnDisk(392, 1, 8))

# ╔═╡ 0e35e132-5e46-4b4c-a3ca-31761ff925a8
(sizeOnDisk(564, 392, 8))

# ╔═╡ 9410b472-7718-436c-a549-af786e97a005
md"""
###### U = (564, 40) σ = (40,) V = (564, 40) for Rank-40 Approximation
"""

# ╔═╡ 28260239-b5b0-4171-aee0-00e0f1d516fc
md"""
###### Total size in the disk: 0.044 MB
"""

# ╔═╡ dae4b12c-7822-4a1b-bc4d-023daf60a1ba
(sizeOnDisk(564, 40, 8))

# ╔═╡ 4805c145-a6b7-4de4-8c45-212540305d6f
(sizeOnDisk(40, 1, 8))

# ╔═╡ f74200ad-6177-4f04-a6d1-1600b9e6c667
(sizeOnDisk(564, 40, 8))

# ╔═╡ c6432711-6085-495d-9e2c-629738ddbb89
md"""
###### U = (564, 20) σ = (20,) V = (564, 20) for Rank-20 Approximation
"""

# ╔═╡ 3356fda4-8fd5-4bdf-860a-99bb2bf6a67a
md"""
###### Total size on the disk: 0.022 MB
"""

# ╔═╡ 07dd8438-488d-409d-9f7b-dba888503582
(sizeOnDisk(564, 20, 8))

# ╔═╡ fc6813ca-07e7-4f21-bb6c-7882125b0c28
(sizeOnDisk(20, 1, 8))

# ╔═╡ 70d4cfcf-96b7-4883-bf9d-796119906182
(sizeOnDisk(564, 20, 8))

# ╔═╡ 265a62f9-6e13-424b-8648-21fbc397534d
begin
	sliced_matrix4 = gray_image_var[1:4:564, 1:4:564]
	sliced_matrix5 = gray_image_var[1:6:564, 1:6:564]
	sliced_matrix6 = gray_image_var[1:8:564, 1:8:564]
	(size(sliced_matrix4), size(sliced_matrix5), size(sliced_matrix6))
end

# ╔═╡ 218b0064-45bd-4b69-bbc3-f736789b747b
md"""
##### Sizes on the disk:
###### Gray scaled original image:
"""

# ╔═╡ 8ce7838f-3866-4e1f-b829-0b8476938de1
(sizeOnDisk(564, 564, 8))

# ╔═╡ af83673f-da28-40c2-bbbc-0f336bd2476b
md"""
###### Step-4 Slicing:
"""

# ╔═╡ 2ddf11d9-d5c8-46eb-ac8d-add9459db634
sizeOnDisk(141, 141, 8)

# ╔═╡ 43b4eedc-374a-4777-8997-5700fc75faf6
md"""
###### Step-6 Slicing:
"""

# ╔═╡ b6456ae6-c1c8-43d6-b4ff-922d8534a52b
sizeOnDisk(94, 94, 8)

# ╔═╡ 71f1975c-7f10-4401-8ff3-f62f8e7ac651
md"""
###### Step-8 Slicing:
"""

# ╔═╡ 5b75f859-36c0-44ba-9667-ff12ca1da0aa
sizeOnDisk(71, 71, 8)

# ╔═╡ ec1203f6-c89f-4dd2-b70a-81141f86092f
begin
	sliced_image4 = imresize(sliced_matrix4, (564,564))
	sliced_image5 = imresize(sliced_matrix5, (564,564))
	sliced_image6 = imresize(sliced_matrix6, (564,564))
end;

# ╔═╡ 9119dd33-05fe-4d29-a05c-2c6eb85be935
md"
$$\begin{aligned}
&\begin{array}{ c  c  c c }
 \text {\bf \large Original}  & \qquad \qquad \text {\bf \large Full-Rank} & \qquad \qquad \text { \bf \large Rank-40 } & \qquad \qquad \text { \bf \large Rank-20 } \\
\end{array}
\end{aligned}$$
"

# ╔═╡ e4000b1a-6c7a-4114-ad73-837d4a97ae71
[gray_image_var Gray.(full_rank_approx) Gray.(rank40_approx) Gray.(rank20_approx)]

# ╔═╡ 63dcb36d-1d56-4db2-ae69-e1cec068285b
md"
$$\begin{aligned}
&\begin{array}{ c  c  c c }
 \text {\bf \large Original}  & \qquad \qquad \text {\bf \large Step-4 } & \qquad \qquad \text { \bf \large Step-6 } & \qquad \qquad \text { \bf \large Step-8 } \\
\end{array}
\end{aligned}$$
"

# ╔═╡ ef667bb9-c14c-44d6-b585-50f08d315558
[gray_image_var sliced_image4 sliced_image5 sliced_image6]

# ╔═╡ 25477922-43cb-4c5b-a8af-f7fceb62ecf1
md"""
###### Sum of Squared Errors
"""

# ╔═╡ 379364ee-b6d0-462b-a42d-283600f35184
let
	error1 = round(sum((matrix_gray - full_rank_approx) .^2), digits = 3)
	error2 = round(sum((matrix_gray - rank40_approx) .^2), digits = 3)
	error3 = round(sum((matrix_gray - rank20_approx) .^2), digits = 3)
	"Full Rank Error: $error1, Rank-40 Error: $error2, Rank-20 Error: $error3"
end

# ╔═╡ 3091aa57-93d7-439e-9c38-0cecfdc24139
let
	error1 = round(sum((matrix_gray - channelview(sliced_image4)) .^2), digits = 2)
	error2 = round(sum((matrix_gray - channelview(sliced_image5)) .^2), digits = 2)
	error3 = round(sum((matrix_gray - channelview(sliced_image6)) .^2), digits = 2)
	"Step-4 Error: $error1, Step-6 Error: $error2, Step-8 Error: $error3"
end

# ╔═╡ aef481a0-e139-4308-bf42-5a24af9fda37
md"""

$$\begin{aligned}
& \text {\bf \ Memory Requirements (MegaBytes)}\\
& \begin{array}{| c | c | c |c |}
 \qquad \text { \ Original } \qquad  & \qquad \text { \ Step-4 } \qquad & \qquad \text { \ Step-6 } \qquad & \qquad \text { \ Step-8 } \qquad \\
\hline \qquad 0.318 \qquad & \qquad 0.020 \qquad & \qquad 0.009 \qquad & \qquad 0.005 \qquad \\
\hline
\end{array}
\end{aligned}$$
"""

# ╔═╡ 66e97024-f2dd-4dc3-a8dc-8e6fc7c17c5d
md"""

$$\begin{aligned}
& \text {\bf \ Memory Requirements (MegaBytes)}\\
& \begin{array}{| c | c | c | c |}
 \qquad \text { \ Original } \qquad  & \qquad \text { \ Full-Rank } \qquad & \qquad \text { \ Rank-40 } \qquad & \qquad \text { \ Rank-20 } \qquad \\
\hline \qquad 0.318 \qquad & \qquad 0.442 \qquad & \qquad 0.044 \qquad & \qquad 0.022 \qquad \\
\hline
\end{array}
\end{aligned}$$
"""

# ╔═╡ 83a20f27-0d20-4239-998b-08d49d8828d5
md"""# Question - 3 (40pts)
### $\color{red} \text{SVD for colored image}$
#### $\qquad - \;$ Apply the SVD to the color image
#### $\qquad - \;$ Compare the orginal image with different rank images
#### $\qquad - \;$ Compare the performance of SVD to the slicing
#### $\qquad \quad \;\circ \;$ memory allocations
#### $\qquad \quad \;\circ \;$ differences from the original (error)

---
"""

# ╔═╡ 0e5f9f90-0f3e-4e61-87dc-f07de9a8c899
begin
	matrix_red = matrix_form[1,:,:]
	matrix_green = matrix_form[2, :, :]
	matrix_blue = matrix_form[3, :, :]
end;

# ╔═╡ 8d4f4499-e816-4ed8-9e8d-3ab5a75c5887
(rank(matrix_red), rank(matrix_green), rank(matrix_blue))

# ╔═╡ baff0eff-a144-4101-9284-747e970f55b5
md"""
###### Full Rank Approximation
"""

# ╔═╡ cfc119c4-932f-43dd-b323-0727eff72612
md"""
###### Total size on the disk: 1.462 MB
"""

# ╔═╡ fdda5e1b-685d-4817-96fc-7150dcab25b0
md"""
###### U = (564, 409) σ = (409,) V = (564, 409) for Red Matrix
###### U = (564, 438) σ = (438,) V = (564, 438) for Green Matrix
###### U = (564, 449) σ = (449,) V = (564, 449) for Blue Matrix
"""

# ╔═╡ bff80c80-3778-45f6-a029-0baae2e4d4c9
md"""
###### Size on the disk for red: 0.462 MB
"""

# ╔═╡ dbc00cf5-114d-44f3-a615-bdc9903f08b5
sizeOnDisk(564, 409, 8)

# ╔═╡ 5788a1d3-5fe3-454c-b6ec-4fbc427a9b56
sizeOnDisk(409, 1, 8)

# ╔═╡ ff233f19-2d8e-46c4-9dd4-266f17efbf4a
sizeOnDisk(564, 409, 8)

# ╔═╡ 920479e8-3f67-4f7f-9135-5449b2243629
md"""
###### Size on the disk for green:  0.494 MB
"""

# ╔═╡ 17825792-dab3-42dd-9cb3-e67cb4dedf15
sizeOnDisk(564, 438, 8)

# ╔═╡ 5ef131e1-c205-4402-ac6a-3becc07c0a96
sizeOnDisk(438, 1, 8)

# ╔═╡ dae5b5f0-c1dd-496c-9a3c-800d41d24231
sizeOnDisk(564, 438, 8)

# ╔═╡ 5295596e-2e02-4859-9fc5-86d69aa00616
md"""
###### Size on the disk for blue: 0.506 MB
"""

# ╔═╡ 1723e2ee-952f-4c6d-a799-c1c72ce9fd20
sizeOnDisk(564, 449, 8)

# ╔═╡ 58e9fceb-a658-4a66-9562-78853d0dc121
sizeOnDisk(449, 1, 8)

# ╔═╡ f540382a-0bd5-45f6-b019-e0e37df86846
sizeOnDisk(564, 449, 8)

# ╔═╡ dc7fdbd6-2050-43f6-901a-c8a568c6bb60
begin
	matrix1_1 = approximator(matrix_red, rank(matrix_red))
	matrix2_1 = approximator(matrix_green, rank(matrix_green))
	matrix3_1 = approximator(matrix_blue, rank(matrix_blue))
	new_matrix_1 = cat(matrix1_1, matrix2_1, matrix3_1, dims=3)
	permuted_matrix_1 = permutedims(new_matrix_1, (3 , 1 , 2))
end;

# ╔═╡ cc877324-dfcb-4ba0-a06a-10283d68d62a
md"""
###### Sum of Sqaured Errors:
"""

# ╔═╡ 3ac9e7f6-1118-4b4f-bdb8-5174c93a057d
let
	error1 = round(sum((matrix_red - matrix1_1) .^2))
	error2 = round(sum((matrix_green - matrix2_1) .^2))
	error3 = round(sum((matrix_blue - matrix3_1) .^2))
	sum_error = error1 + error2 + error3
end

# ╔═╡ 871a3035-30b1-490d-8d9e-1bf22a17d297
md"""
###### Rank-40 Approximation
"""

# ╔═╡ c6289aae-54e7-411e-9c19-aa3d8c324d2b
md"""
###### U = (564, 40) σ = (40,) V = (564, 40) for Red, Green and Blue Matrices
"""

# ╔═╡ 67f1cc1e-8905-4aee-950f-a7342acd69b1
md"""
###### Total size on the disk: 0.138 MB
"""

# ╔═╡ 0b092106-69a7-441a-bb58-f3b3bc5f2697
sizeOnDisk(564, 40, 24)

# ╔═╡ 03aa2b17-b844-4ece-a970-100c35fcfb47
sizeOnDisk(40, 1, 24)

# ╔═╡ c5e4c765-b152-481b-a3a5-093c8274d1bf
sizeOnDisk(564, 40, 24)

# ╔═╡ 24bbfaaf-0f64-4495-848f-dd4f7b884adb
begin
	matrix1_2 = approximator(matrix_red, 40)
	matrix2_2 = approximator(matrix_green, 40)
	matrix3_2 = approximator(matrix_blue, 40)
	new_matrix_2 = cat(matrix1_2, matrix2_2, matrix3_2, dims=3)
	permuted_matrix_2 = permutedims(new_matrix_2, (3 , 1 , 2))
end;

# ╔═╡ e571aa1c-2674-45c0-9083-15b93cd05247
md"""
###### Sum of Sqaured Errors:
"""

# ╔═╡ 165e7c16-0311-4ac7-8460-0401b15a7aac
let
	error1 = round(sum((matrix_red - matrix1_2) .^2))
	error2 = round(sum((matrix_green - matrix2_2) .^2))
	error3 = round(sum((matrix_blue - matrix3_2) .^2))
	sum_error = error1 + error2 + error3
end

# ╔═╡ 36c3e660-1beb-45a4-959b-532903f61bb0
md"""
###### Rank-20 Approximation
"""

# ╔═╡ cfb8f58b-fa1d-4a8f-9ce8-b01e4398a659
md"""
###### U = (564, 20) σ = (20,) V = (564, 20) for Red, Green and Blue Matrices
"""

# ╔═╡ 73956dae-985c-4f98-83d7-07f25e036849
md"""
###### Total size on the disk: 0.068 MB
"""

# ╔═╡ a707605a-7997-4979-a824-5032ca6beaac
sizeOnDisk(564, 20, 24)

# ╔═╡ a432b549-3c8f-4e08-8b74-2268311adc19
sizeOnDisk(20, 1, 24)

# ╔═╡ ce7c52f8-668a-4371-8b5b-6a1bd177fbfa
sizeOnDisk(564, 20, 24)

# ╔═╡ e79a7f6a-b5c6-4735-863d-5e36b012b80e
begin
	matrix1_3 = approximator(matrix_red, 20)
	matrix2_3 = approximator(matrix_green, 20)
	matrix3_3 = approximator(matrix_blue, 20)
	new_matrix_3 = cat(matrix1_3, matrix2_3, matrix3_3, dims=3)
	permuted_matrix_3 = permutedims(new_matrix_3, (3 , 1 , 2))
end;

# ╔═╡ 40a63abe-0045-4656-bdeb-bea39ab6fbf8
md"""
###### Sum of Squared Errors:
"""

# ╔═╡ 9bc68f7d-17cc-439f-958c-319c732a9a69
let
	error1 = round(sum((matrix_red - matrix1_3) .^2))
	error2 = round(sum((matrix_green - matrix2_3) .^2))
	error3 = round(sum((matrix_blue - matrix3_3) .^2))
	sum_error = error1 + error2 + error3
end

# ╔═╡ b7283311-f7ca-482d-ae13-bcb8519cfcf7
md"
$$\begin{aligned}
&\begin{array}{ c  c  c c }
 \text {\bf \large Original}  & \qquad \qquad \text {\bf \large Full-Rank} & \qquad \qquad \text { \bf \large Rank-40 } & \qquad \qquad \text { \bf \large Rank-20 } \\
\end{array}
\end{aligned}$$
"

# ╔═╡ d3625d20-e6ce-11ea-394a-53208540d626
[image_var colorview(RGB, permuted_matrix_1) colorview(RGB, permuted_matrix_2) colorview(RGB, permuted_matrix_3)]

# ╔═╡ 0a3a194b-77cd-43d8-a0c3-182cf0aa3e25
md"
$$\begin{aligned}
&\begin{array}{ c  c  c c }
 \text {\bf \large Original}  & \qquad \qquad \text {\bf \large Step-4 } & \qquad \qquad \text { \bf \large Step-6 } & \qquad \qquad \text { \bf \large Step-8 } \\
\end{array}
\end{aligned}$$
"

# ╔═╡ 74fb6b63-dd86-4539-b745-62c438acb1e3
[image_var sliced_image1 sliced_image2 sliced_image3]

# ╔═╡ 73e620d5-fb45-47bb-b9d4-816688f121bc
md"""
###### Original image:
"""

# ╔═╡ 68588802-9a33-4687-883e-120ddd0de19a
(sizeOnDisk(564, 564, 24))

# ╔═╡ e95efb2f-135f-4fca-9299-b6405b94cfbc
md"""
###### Step-4 Slicing:
"""

# ╔═╡ d2e42118-fad4-4b8f-9ed5-88feb3573d23
sizeOnDisk(141, 141, 24)

# ╔═╡ 139dac1a-def8-4711-951e-6c2ca4939136
md"""
###### Step-6 Slicing:
"""

# ╔═╡ e1053533-7af9-4f3e-b54f-5648dbd5f6d9
sizeOnDisk(94, 94, 24)

# ╔═╡ 4135f484-dcb9-4ede-a2bd-4d727a734816
md"""
###### Step-8 Slicing:
"""

# ╔═╡ 63c99cae-a8aa-4433-8f3b-627fe0a31b83
sizeOnDisk(71, 71, 24)

# ╔═╡ 316a0f4f-0db9-458f-b0c6-8c36403ec008
md"""

$$\begin{aligned}
& \text {\bf \ Memory Requirements (MegaBytes)}\\
& \begin{array}{| c | c | c |c |}
 \qquad \text { \ Original } \qquad  & \qquad \text { \ Step-4 } \qquad & \qquad \text { \ Step-6 } \qquad & \qquad \text { \ Step-8 } \qquad \\
\hline \qquad 0.954 \qquad & \qquad 0.060 \qquad & \qquad 0.026 \qquad & \qquad 0.0015 \qquad \\
\hline
\end{array}
\end{aligned}$$
"""

# ╔═╡ 89a05c0c-20fa-4a83-ab40-9b84e0da6abd
md"""

$$\begin{aligned}
& \text {\bf \ Memory Requirements (MegaBytes)}\\
& \begin{array}{| c | c | c |c |}
 \qquad \text { \ Original } \qquad  & \qquad \text { \ Full-Rank } \qquad & \qquad \text { \ Rank-40 } \qquad & \qquad \text { \ Rank-20} \qquad \\
\hline \qquad 0.954 \qquad & \qquad 1.462 \qquad & \qquad 0.138 \qquad & \qquad 0.068 \qquad \\
\hline
\end{array}
\end{aligned}$$
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Images = "~0.26.0"
PlutoUI = "~0.7.53"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "b68cd00ce65b7f0861dd8e38a59e2988a11bd187"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "02f731463748db57cc2ebfbd9fbc9ce8280d3433"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.1"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "16267cf279190ca7c1b30d020758ced95db89cd0"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.5.1"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "0c5f81f47bbbcf4aea7b2959135713459170798b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.5"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "601f7e7b3d36f18790e2caf83a882d88e9b71ff1"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.4"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "e0af648f0692ec1691b5d094b8724ba1346281cf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.18.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "70232f82ffaab9dc52585e0dd043b5e0c6b714f1"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.12"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "05f9816a77231b07e634ab8715ba50e5249d6f76"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.5"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f9d7112bfff8a19a3a4ea4e03a8e6a91fe8456bf"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.3"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "5225c965635d8c21168e32a12954675e7bea1151"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.10"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "b4fbdd20c889804969571cc589900803edda16b7"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.7.1"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "899050ace26649433ef1af25bc17a815b3db52b7"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.9.0"

[[deps.HistogramThresholding]]
deps = ["ImageBase", "LinearAlgebra", "MappedArrays"]
git-tree-sha1 = "7194dfbb2f8d945abdaf68fa9480a965d6661e69"
uuid = "2c695a8d-9458-5d45-9878-1b8a99cf7853"
version = "0.3.1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "eb8fed28f4994600e29beef49744639d985a04b2"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.16"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageBinarization]]
deps = ["HistogramThresholding", "ImageCore", "LinearAlgebra", "Polynomials", "Reexport", "Statistics"]
git-tree-sha1 = "f5356e7203c4a9954962e3757c08033f2efe578a"
uuid = "cbc4b850-ae4b-5111-9e64-df94c024a13d"
version = "0.3.0"

[[deps.ImageContrastAdjustment]]
deps = ["ImageBase", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "eb3d4365a10e3f3ecb3b115e9d12db131d28a386"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.12"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "fc5d1d3443a124fde6e92d0260cd9e064eba69f8"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.1"

[[deps.ImageCorners]]
deps = ["ImageCore", "ImageFiltering", "PrecompileTools", "StaticArrays", "StatsBase"]
git-tree-sha1 = "24c52de051293745a9bad7d73497708954562b79"
uuid = "89d5987c-236e-4e32-acd0-25bd6bd87b70"
version = "0.1.3"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "08b0e6354b21ef5dd5e49026028e41831401aca8"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.17"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "PrecompileTools", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "432ae2b430a18c58eb7eca9ef8d0f2db90bc749c"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.8"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "bca20b2f5d00c4fbc192c3212da8fa79f4688009"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.7"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils"]
git-tree-sha1 = "b0b765ff0b4c3ee20ce6740d843be8dfce48487c"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.3.0"

[[deps.ImageMagick_jll]]
deps = ["JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1c0a2295cca535fabaf2029062912591e9b61987"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.10-12+3"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.ImageMorphology]]
deps = ["DataStructures", "ImageCore", "LinearAlgebra", "LoopVectorization", "OffsetArrays", "Requires", "TiledIteration"]
git-tree-sha1 = "6f0a801136cb9c229aebea0df296cdcd471dbcd1"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.4.5"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "PrecompileTools", "Statistics"]
git-tree-sha1 = "783b70725ed326340adf225be4889906c96b8fd1"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.7"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "3ff0ca203501c3eedde3c6fa7fd76b703c336b5f"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.8.2"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "7ec124670cbce8f9f0267ba703396960337e54b5"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.10.0"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageBinarization", "ImageContrastAdjustment", "ImageCore", "ImageCorners", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "d438268ed7a665f8322572be0dabda83634d5f45"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.26.0"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3d09a9f60edf77f8a4d99f9e015e8fbf9989605d"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.7+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ad37c091f7d7daf900963171600d7c1c5c3ede32"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2023.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.IntervalSets]]
deps = ["Dates", "Random"]
git-tree-sha1 = "3d8866c029dd6b16e69e0d4a939c4dfcb98fac47"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.8"
weakdeps = ["Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsStatisticsExt = "Statistics"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "4ced6667f9974fc5c5943fa5e2ef1ca43ea9e450"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.8.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "PrecompileTools", "Printf", "Reexport", "Requires", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "9bbb5130d3b4fa52846546bca4791ecbdfb52730"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.38"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "d65930fa2bc96b07d7691c652d701dcbe7d9cf0b"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "62edfee3211981241b57ff1cedf4d74d79519277"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.15"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "0f5648fbae0d015e3abe5867bca2b362f67a5894"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.166"

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.LoopVectorization.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "eb006abbd7041c28e0d16260e50a24f8f9104913"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2023.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "1130dbe1d5276cb656f6e1094ce97466ed700e5a"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "2c3726ceb3388917602169bed973dbc97f1b51a8"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.13"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "2ac17d29c523ce1cd38e27785a7d23024853a4bb"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.10"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "a4ca623df1ae99d09bc9868b008262d0c0ac1e4f"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.4+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "5ded86ccaf0647349231ed6c0822c10886d4a1ee"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.1"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "db8ec28846dbf846228a32de5a6912c63e2052e3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.53"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "240d7170f5ffdb285f9427b92333c3463bf65bf6"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.1"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "3aa2bb4982e575acd7583f01531f241af077b163"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.13"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsMakieCoreExt = "MakieCore"
    PolynomialsMutableArithmeticsExt = "MutableArithmetics"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    MakieCore = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
    MutableArithmetics = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "00099623ffee15972c16111bcf84c58a0051257c"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.9.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "da095158bdc8eaccb7890f9884048555ab771019"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "792d8fd4ad770b6d517a13ebb8dadfcac79405b8"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.6.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "3aac6d68c5e57449f5b9b865c9ba50ac2970c4cf"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.42"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "f295e0a1da4ca425659c57441bcb59abb035a4bc"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.8.8"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Requires", "SparseArrays", "Static", "SuiteSparse"]
git-tree-sha1 = "03fec6800a986d191f64f5c0996b59ed526eda25"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.4.1"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "0adf069a2a490c47273727e029371b31d44b72b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.5"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "34cc045dd0aaa59b8bbe86c644679bc57f1d5bd0"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.8"

[[deps.TiledIteration]]
deps = ["OffsetArrays", "StaticArrayInterface"]
git-tree-sha1 = "1176cc31e867217b06928e2f140c90bd1bc88283"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.5.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "b182207d4af54ac64cbc71797765068fdeff475d"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.64"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═7a7a04c2-cb31-47fe-8598-075241d06a38
# ╟─fafae38e-e852-11ea-1208-732b4744e4c2
# ╟─cdff6730-e785-11ea-2546-4969521b33a7
# ╟─7308bc54-e6cd-11ea-0eab-83f7535edf25
# ╟─95d94d54-7229-4204-882b-45db699e421f
# ╟─a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
# ╠═3638a9c6-5ce2-487e-b16a-84a025ede8c0
# ╟─499b8010-e89d-4e73-b5bc-d6ed9fab4986
# ╠═08e0af6c-81a7-447e-b141-4265e5421706
# ╠═747dea3b-1ea0-4fca-9b23-82db95a5179f
# ╟─00c3c2d8-07ef-486f-af16-d2cc8611d7be
# ╠═e04421c7-30ef-40e8-b382-b9351db5847a
# ╠═761cc39e-2713-40b5-bd9c-9b74a0853afd
# ╟─297ba9e1-c690-48e4-beba-08e1485b573c
# ╠═4423a8e5-8513-4c75-96a9-9cd1dd54e1c1
# ╟─427c24b5-c009-4338-9152-84957751d726
# ╠═84478d8a-6fc1-4239-a502-b1fff0d063c9
# ╠═63c6e61b-8ded-4d59-80c9-d959f2544efe
# ╠═f6837d47-e61b-4fa2-828e-908c91dff0b5
# ╠═5521e3db-70ff-4247-b65a-d9b4d8b3575c
# ╠═3e4bcb44-685a-4bb4-a1f6-67584d3d790c
# ╠═2c32db5e-ce4c-4671-9e54-2665a7dcfed8
# ╟─93383358-dc44-4c6b-8a68-1e5c126af09f
# ╟─2e827f88-4ec1-4c3a-bcb5-64d70716adda
# ╠═096bb645-6c03-4842-8584-e9a9cd98567b
# ╠═f550b6f6-27f5-4fa6-a838-31ab983aa329
# ╠═0e35e132-5e46-4b4c-a3ca-31761ff925a8
# ╟─9410b472-7718-436c-a549-af786e97a005
# ╟─28260239-b5b0-4171-aee0-00e0f1d516fc
# ╠═dae4b12c-7822-4a1b-bc4d-023daf60a1ba
# ╠═4805c145-a6b7-4de4-8c45-212540305d6f
# ╠═f74200ad-6177-4f04-a6d1-1600b9e6c667
# ╟─c6432711-6085-495d-9e2c-629738ddbb89
# ╟─3356fda4-8fd5-4bdf-860a-99bb2bf6a67a
# ╠═07dd8438-488d-409d-9f7b-dba888503582
# ╠═fc6813ca-07e7-4f21-bb6c-7882125b0c28
# ╠═70d4cfcf-96b7-4883-bf9d-796119906182
# ╠═265a62f9-6e13-424b-8648-21fbc397534d
# ╟─218b0064-45bd-4b69-bbc3-f736789b747b
# ╠═8ce7838f-3866-4e1f-b829-0b8476938de1
# ╟─af83673f-da28-40c2-bbbc-0f336bd2476b
# ╠═2ddf11d9-d5c8-46eb-ac8d-add9459db634
# ╟─43b4eedc-374a-4777-8997-5700fc75faf6
# ╠═b6456ae6-c1c8-43d6-b4ff-922d8534a52b
# ╟─71f1975c-7f10-4401-8ff3-f62f8e7ac651
# ╠═5b75f859-36c0-44ba-9667-ff12ca1da0aa
# ╠═ec1203f6-c89f-4dd2-b70a-81141f86092f
# ╟─9119dd33-05fe-4d29-a05c-2c6eb85be935
# ╠═e4000b1a-6c7a-4114-ad73-837d4a97ae71
# ╟─63dcb36d-1d56-4db2-ae69-e1cec068285b
# ╠═ef667bb9-c14c-44d6-b585-50f08d315558
# ╟─25477922-43cb-4c5b-a8af-f7fceb62ecf1
# ╠═379364ee-b6d0-462b-a42d-283600f35184
# ╠═3091aa57-93d7-439e-9c38-0cecfdc24139
# ╟─aef481a0-e139-4308-bf42-5a24af9fda37
# ╟─66e97024-f2dd-4dc3-a8dc-8e6fc7c17c5d
# ╟─83a20f27-0d20-4239-998b-08d49d8828d5
# ╠═0e5f9f90-0f3e-4e61-87dc-f07de9a8c899
# ╠═8d4f4499-e816-4ed8-9e8d-3ab5a75c5887
# ╟─baff0eff-a144-4101-9284-747e970f55b5
# ╟─cfc119c4-932f-43dd-b323-0727eff72612
# ╟─fdda5e1b-685d-4817-96fc-7150dcab25b0
# ╟─bff80c80-3778-45f6-a029-0baae2e4d4c9
# ╠═dbc00cf5-114d-44f3-a615-bdc9903f08b5
# ╠═5788a1d3-5fe3-454c-b6ec-4fbc427a9b56
# ╠═ff233f19-2d8e-46c4-9dd4-266f17efbf4a
# ╟─920479e8-3f67-4f7f-9135-5449b2243629
# ╠═17825792-dab3-42dd-9cb3-e67cb4dedf15
# ╠═5ef131e1-c205-4402-ac6a-3becc07c0a96
# ╠═dae5b5f0-c1dd-496c-9a3c-800d41d24231
# ╟─5295596e-2e02-4859-9fc5-86d69aa00616
# ╠═1723e2ee-952f-4c6d-a799-c1c72ce9fd20
# ╠═58e9fceb-a658-4a66-9562-78853d0dc121
# ╠═f540382a-0bd5-45f6-b019-e0e37df86846
# ╠═dc7fdbd6-2050-43f6-901a-c8a568c6bb60
# ╟─cc877324-dfcb-4ba0-a06a-10283d68d62a
# ╠═3ac9e7f6-1118-4b4f-bdb8-5174c93a057d
# ╟─871a3035-30b1-490d-8d9e-1bf22a17d297
# ╟─c6289aae-54e7-411e-9c19-aa3d8c324d2b
# ╠═67f1cc1e-8905-4aee-950f-a7342acd69b1
# ╠═0b092106-69a7-441a-bb58-f3b3bc5f2697
# ╠═03aa2b17-b844-4ece-a970-100c35fcfb47
# ╠═c5e4c765-b152-481b-a3a5-093c8274d1bf
# ╠═24bbfaaf-0f64-4495-848f-dd4f7b884adb
# ╟─e571aa1c-2674-45c0-9083-15b93cd05247
# ╠═165e7c16-0311-4ac7-8460-0401b15a7aac
# ╟─36c3e660-1beb-45a4-959b-532903f61bb0
# ╟─cfb8f58b-fa1d-4a8f-9ce8-b01e4398a659
# ╟─73956dae-985c-4f98-83d7-07f25e036849
# ╠═a707605a-7997-4979-a824-5032ca6beaac
# ╠═a432b549-3c8f-4e08-8b74-2268311adc19
# ╠═ce7c52f8-668a-4371-8b5b-6a1bd177fbfa
# ╠═e79a7f6a-b5c6-4735-863d-5e36b012b80e
# ╟─40a63abe-0045-4656-bdeb-bea39ab6fbf8
# ╠═9bc68f7d-17cc-439f-958c-319c732a9a69
# ╟─b7283311-f7ca-482d-ae13-bcb8519cfcf7
# ╠═d3625d20-e6ce-11ea-394a-53208540d626
# ╟─0a3a194b-77cd-43d8-a0c3-182cf0aa3e25
# ╠═74fb6b63-dd86-4539-b745-62c438acb1e3
# ╟─73e620d5-fb45-47bb-b9d4-816688f121bc
# ╠═68588802-9a33-4687-883e-120ddd0de19a
# ╟─e95efb2f-135f-4fca-9299-b6405b94cfbc
# ╠═d2e42118-fad4-4b8f-9ed5-88feb3573d23
# ╟─139dac1a-def8-4711-951e-6c2ca4939136
# ╠═e1053533-7af9-4f3e-b54f-5648dbd5f6d9
# ╟─4135f484-dcb9-4ede-a2bd-4d727a734816
# ╠═63c99cae-a8aa-4433-8f3b-627fe0a31b83
# ╟─316a0f4f-0db9-458f-b0c6-8c36403ec008
# ╟─89a05c0c-20fa-4a83-ab40-9b84e0da6abd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
