def compare_files(file1_path, file2_path):
    with open(file1_path, 'r', encoding='utf-8') as file1, open(file2_path, 'r', encoding='utf-8') as file2:
        lines1 = file1.readlines()
        lines2 = file2.readlines()

    # 查找不同的行数
    diff_lines = [i + 1 for i, (line1, line2) in enumerate(zip(lines1, lines2)) if line1 != line2]

    # 输出不同的行数
    if diff_lines:
        print("不同的行数：", diff_lines)
    else:
        print("文件相同。")

# 调用比较函数
file1_path = '/home/liam/CA/lab3/test/123/lab3/output_2.txt'
file2_path = '/home/liam/CA/lab3/test/123/lab3/testcases/output_2.txt'
compare_files(file1_path, file2_path)
