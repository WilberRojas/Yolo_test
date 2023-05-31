# variables
repo_url="https://github.com/ultralytics/yolov5.git"
branch_name="v6.1"
yml_url="https://raw.githubusercontent.com/WilberRojas/Yolo_test/main/environment.yml"
req_url="https://raw.githubusercontent.com/WilberRojas/Yolo_test/main/requirements.txt"
weights_url="https://github.com/ultralytics/yolov5/releases/v6.1/"

# 1-Get the code
echo -e "\e[1;33m-Step 1: Cloning the repository\e[0m"
read -p "Do you want to clone the repository? (y/N): " -i "N" response
if [[ "$response" == "Y" || "$response" == "y" ]]; then    
    
    git clone --branch "$branch_name" "$repo_url" > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo -e "\e[1;31mError: Failed to clone the repository.\e[0m"
        exit 1
    fi
    echo -e "\e[1;32mThe repository has been cloned successfully.\e[0m"
else
    echo -e "\e[38;5;166mThe repository will not be cloned.\e[0m"
fi

# 2-Create the environment
echo -e "\e[1;33m-Step 2: Create the Python environment\e[0m"
read -p "Do you want to create the environment? (y/N): " -i "N" response
if [[ "$response" == "Y" || "$response" == "y" ]]; then
    
    read -p "Enter the name of the environment: " environment_name
    read -p "Select the environment type (conda/venv): " environment_type


    if [[ "$environment_type" == "conda" ]]; then
        # Conda environment logic
        echo "You have selected Conda."
        wget "$yml_url" > /dev/null 2>&1
        conda env create -n "$environment_name" -f environment.yml
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31mError: Failed to create the $environment_name environment.\e[0m"
            exit 1
        fi
        conda deactivate $$ deactivate
        conda activate "$environment_name"
        echo -e "\e[1;32mThe $environment_name environment has been created successfully.\e[0m"
        
    elif [[ "$environment_type" == "venv" ]]; then
        # venv environment logic
        echo "You have selected venv."
        wget "$req_url" > /dev/null 2>&1
        cd yolov5
        python3 -m venv "$environment_name" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31mError: Failed to create the $environment_name environment.\e[0m"
            exit 1
        fi
        conda deactivate $$ deactivate
        source "$environment_name"/bin/activate > /dev/null 2>&1
        pip install -r requirements.txt
        echo -e "\e[1;32mThe $environment_name environment has been created successfully.\e[0m"
        cd ..
    else
        echo -e "\e[1;31mInvalid option. Please select 'conda' or 'venv'.\e[0m"
    fi
else    
    echo -e "\e[38;5;166mThe environment will not be created.\e[0m"
fi

# 3-Download weights (.pt files)
echo -e "\e[1;33m-Step 3: Downloading weights.\e[0m"
echo -e "\e[1;34m   You can check available weights on $weights_url\e[0m"

read -p "Do you want to download weights? (y/N): " -i "N" response
if [[ "$response" == "Y" || "$response" == "y" ]]; then
    mkdir yolov5/weights > /dev/null 2>&1
    cd yolov5/weights
    echo -e "\e[1;33msavin on 'yolov5/weights'\e[0m"
    read -p "Which weight do you want to download? (e.g=yolov5l): " weight_name
    wget "https://github.com/ultralytics/yolov5/releases/download/v6.1/$weight_name.pt" #maybe this change for different models
    cd ../..    

else    
    echo -e "\e[38;5;166mThe weights will not be downloaded.\e[0m"
fi

# 4-Test the model (.pt files)
echo -e "\e[1;33m-Step 4: Test the Model.\e[0m"
read -p "Do you want to Test the Model (run detect.py)? (y/N): " -i "N" response
if [[ "$response" == "Y" || "$response" == "y" ]]; then
    cd yolov5/weights   
    read -e -p "Please select one downloaded weight. (use Tab to see options): " weight_name
    cd ..
    mkdir images > /dev/null 2>&1
    cd images
    wget https://github.com/WilberRojas/Yolo_test/raw/main/test.jpg    
    cd ..    
    python detect.py --weights "weights/$weight_name" --source images/test.jpg
    cd ..
fi