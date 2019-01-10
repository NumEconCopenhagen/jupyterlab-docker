# Includes Julia, Python and R
FROM jupyter/datascience-notebook

COPY environment.yml ${HOME}/environment.yml

# Add dependencies
RUN conda env update -f environment.yml --quiet && \
    rm -fr work environment.yml

# Enable extension manager
RUN mkdir -p .jupyter/lab/user-settings/\@jupyterlab/extensionmanager-extension/ && \
    printf "{\n\t\"enabled\" : true\n}" >> .jupyter/lab/user-settings/\@jupyterlab/extensionmanager-extension/plugin.jupyterlab-settings

# Add extensions
RUN jupyter labextension install \
    https://github.com/rmotr/jupyterlab-solutions \
    @ijmbarr/jupyterlab_spellchecker \
    @jupyterlab/git \
    @jupyterlab/github \
    @jupyterlab/latex \
    @jupyterlab/statusbar \
    @jupyterlab/toc \
    @rmotr/jupyterlab-solutions \
    @ryantam626/jupyterlab_code_formatter \
    jupyterlab_toastify \
    jupyterlab_conda

# Add server extensions
RUN jupyter serverextension enable jupyter_conda && \
    jupyter serverextension enable jupyterlab_code_formatter && \
    jupyter serverextension enable jupyterlab_git && \
    jupyter serverextension enable jupyterlab_github && \
    jupyter serverextension enable jupyterlab_rmotr_solutions

# Install variable inspector
USER root
RUN git clone https://github.com/lckr/jupyterlab-variableInspector /opt/jupyterlab-variableInspector && \
    chmod 777 /opt/jupyterlab-variableInspector

USER $NB_USER

RUN cd /opt/jupyterlab-variableInspector && \
    npm install && \
    npm run build && \
    jupyter labextension install .