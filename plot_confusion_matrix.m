function plot_confusion_matrix(conf_matrix, labels, title_text)
    figure;
    heatmap(labels, labels, conf_matrix, 'Colormap', parula, 'ColorbarVisible', 'on');
    title(title_text);
    xlabel('Predicted Labels');
    ylabel('True Labels');
end
