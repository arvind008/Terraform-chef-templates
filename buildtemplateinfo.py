#!/usr/bin/env python

import argparse
import json
import os
import shutil
import traceback


def check_list(data_list, new_templates, tmp_list, t_type):
    """
    Check list of templates
    :param data_list:
    :param new_templates:
    :param tmp_list:
    :return:
    """
    if tmp_list:
        if data_list.get("name") in tmp_list and data_list.get("target_cloud") == t_type:
            new_templates.append(data_list)
    return new_templates


def generate_info_file(path, url, ui_root, logo_path, dir_path):
    available_templates = []

    if not os.path.exists(os.path.join(ui_root, logo_path)):
        os.makedirs(os.path.join(ui_root, logo_path))

    print "Started looking for available templates ..."
    templates = [
        dir_name for dir_name in os.listdir(path)
        if os.path.isdir(os.path.join(path, dir_name)) and not dir_name.startswith(".")
    ]

    print "Found templates:", templates

    print "Looking for templates info ..."
    for template in templates:
        try:
            templateinfo = os.path.join(path, template, "template_info.json")
            print templateinfo
            with open(templateinfo, "r") as fin:
                info = json.load(fin)
                data = dict()
                for key, value in info.items():
                    if key == "logo" and not value:
                        if os.path.exists(os.path.join(path, template, "logo.png")):
                            print "found logo for", template
                            shutil.copyfile(
                                os.path.join(path, template, "logo.png"),
                                os.path.join(ui_root, logo_path, template + ".png")
                            )

                            data["logo"] = logo_path + "/" + template + ".png"
                    else:
                        data[key.lower()] = str(value)
                data["path"] = os.path.join(path, template)
                data["url"] = "{}/{}".format(url, template)
                if "logo" not in data:
                    data["logo"] = None
                available_templates.append(data)
        except Exception as err:
            print err
            traceback.print_exc()

    print "Writing available templates info ..."
    new_templates = []
    if os.path.exists("/etc/SF_PRODUCTION"):
        list_file = os.path.join(path, "templates_list_production.json")
        with open(list_file, "r") as fp:
            dict_list = json.loads(fp.read())
        for data_list in available_templates:
            for acc_type in dict_list.keys():
                tmp_list = dict_list.get(acc_type)
                if tmp_list:
                    check_list(data_list, new_templates, tmp_list, acc_type)
    else:
        new_templates = available_templates
    print "templates", new_templates
    with open("catalog.json", "w") as fout:
        json.dump(new_templates, fout, indent=4, sort_keys=True)


if __name__ == '__main__':
    git_url = "https://github.com/pramurthy/MulticloudOrchestration/tree/templates"

    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--logo-path',
                        dest="logo_path",
                        help='path where logos has to be copied',
                        action="store",
                        required=True)
    parser.add_argument('-r', '--ui-root',
                        dest="ui_root",
                        help='path to dist directory',
                        action="store",
                        required=True)
    parser.add_argument('-p', '--dir-path',
                        dest="dir_path",
                        help='path to code directory',
                        action="store",
                        default=os.getcwd())

    args = parser.parse_args()
    print "args:"
    print "  logo_path:", args.logo_path
    print "  ui_root:", args.ui_root
    print "  cwd:", os.getcwd()
    print "  git url:", git_url

    generate_info_file(
        os.getcwd(),
        git_url,
        args.ui_root,
        args.logo_path,
        args.dir_path
    )
